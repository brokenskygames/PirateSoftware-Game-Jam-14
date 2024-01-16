extends CharacterBody2D
var Bullet = preload("res://bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var dir
	get_input()
	dir = get_global_mouse_position() - global_position
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if dir.length() > 5:
		$Muzzle.rotation = dir.angle()

	
func get_input():
	# Add these actions in Project Settings -> Input Map.
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func shoot():
	var bullet_spread
	var bullet_speed = 200	
	var shoot_direction = $Muzzle.rotation
	#var spread_arc = deg_to_rad(30) 
	for i in range(0,8):
		#if (i % 2) == 0:		
		for spread in range (-5,5):			
			bullet_spread = Bullet.instantiate()
			bullet_spread.start($Muzzle.global_position, shoot_direction+spread*0.05,bullet_speed)
			get_tree().root.add_child(bullet_spread)		
		await get_tree().create_timer(0.03).timeout
		#else:
			#for spread in range (-12,12):			
				#bullet_spread = Bullet.instantiate()
				#bullet_spread.start($Muzzle.global_position, shoot_direction+spread*0.03,bullet_speed)
				#get_tree().root.add_child(bullet_spread)		
			#await get_tree().create_timer(0.05).timeout
		


	
