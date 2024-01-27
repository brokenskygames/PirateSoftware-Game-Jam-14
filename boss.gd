extends CharacterBody2D

var Pew = preload("res://pew.tscn")

var movement_range = 350
var center_position
var enemy_detect = false
var enemy_position_x = 1
var enemy_jump = false
var health = 500
var cooldown = false
var end_game = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	center_position = position
	velocity.x = 10
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	var floating
	if end_game:
		get_tree().change_scene_to_file("res://Menus/MainMenu.tscn") 

	if $AnimatedSprite2D.animation != "finish":
		$AnimatedSprite2D.play("idle")

		if position.x < center_position.x+movement_range:
			
			velocity.x += 4
		else:
			velocity.x -= 4
		#if position.y < center_position.y+movement_range:
			#velocity.y += 1
		#else:
			#velocity.y -= 1
	else: 
		velocity.x = 0

	if velocity.x < -0.1:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0.1:
		$AnimatedSprite2D.flip_h = false
	position += velocity * delta
	move_and_slide()
	
	var shoot_direction = deg_to_rad(randfn(0,40)+90)
	var bullet_speed = 500
	if !cooldown:
		var pew = Pew.instantiate()
		pew.start($AnimatedSprite2D.global_position,shoot_direction,bullet_speed-randfn(1,10))
		get_tree().root.add_child(pew)
		cooldown = true
		$cooldown.start()
	
	

func _on_get_hit_body_entered(body):	
	body.queue_free()
	if $AnimatedSprite2D.animation != "finish":
		$AnimatedSprite2D.play("hit")
	health -= 1
	if health <= 0:
		velocity.x = 0
		$AnimatedSprite2D.play("finish")
		await $AnimatedSprite2D.animation_finished
		end_game = true
		
		
	
func _on_cooldown_timeout():
	cooldown = false
