extends CharacterBody2D

var movement_range = 40
var center_position
var enemy_detect = false
var enemy_position_x = 1
var enemy_jump = false
var health = 250


const SPEED = 300.0
const JUMP_VELOCITY = -400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	center_position = position
	velocity.x = 10
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	var floating
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity*0.5 * delta

	# Handle jump.
	if !enemy_detect:
		if position.x < center_position.x+movement_range:
			velocity.x += 1
		else:
			velocity.x -= 1
	else:		
		center_position.x = position.x
		
		if $AnimatedSprite2D.animation != "died":
			$AnimatedSprite2D.play("atack")
			velocity.x = enemy_position_x*80
		else: 
			velocity.x = 0
		
		
	if velocity.x < -0.1:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0.1:
		$AnimatedSprite2D.flip_h = false
	position += velocity * delta
	move_and_slide()
	
	
func _on_area_2d_body_entered(body):
	enemy_detect = true
	if body.position.x > position.x:
		enemy_position_x = 1
	else:
		enemy_position_x = -1 

	

func _on_area_2d_body_exited(body):
	enemy_detect = true
	if body.position.x > position.x:
		enemy_position_x = 1
	else:
		enemy_position_x = -1 


func _on_get_hit_body_entered(body):
	body.queue_free()
	health -= 1
	if health <= 0:
		velocity.x = 0
		$AnimatedSprite2D.play("died")
		await $AnimatedSprite2D.animation_finished
		self.queue_free()
	
	
	
	
	
	
