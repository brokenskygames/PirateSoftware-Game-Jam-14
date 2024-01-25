extends CharacterBody2D
var Bullet = preload("res://player/bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var stop = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	$Sprites/weapon_1.hide()
	var dir
	get_input()
	dir = get_global_mouse_position() - global_position
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and !stop:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()	
	move_and_slide()
	if velocity.x < -0.1:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0.1:
		$AnimatedSprite2D.flip_h = false
	
	
	if dir.length() > 5:
		$Sprites/weapon_1.rotation = dir.angle()
		$Sprites/weapon_1/Muzzle.rotation = dir.angle()

	
func get_input():
	if Input.is_action_pressed("alt_shoot"):
		stop = true
		$AnimatedSprite2D.animation = "aim"
		$Sprites/weapon_1.show()
		var shoot_direction = rad_to_deg($Sprites/weapon_1/Muzzle.rotation)
		if shoot_direction > -90 and shoot_direction < 90:
			velocity.x = 0
			$AnimatedSprite2D.flip_h = false
			$Sprites/weapon_1.flip_h = false
			$Sprites/weapon_1.flip_v = false
		else: 
			velocity.x = 0
			$AnimatedSprite2D.flip_h = true
			$Sprites/weapon_1.flip_h = false
			$Sprites/weapon_1.flip_v = true
		if Input.is_action_just_pressed("shoot"):
			shoot_1()
			
	else:
		stop = false
		

func shoot_1():
	var bullet_speed = 200 
	var spread_arc = 20
	var step = 30	
	var wave_weights = [1,2]
	var bullet_weights = [3,1,3]	
	sonic_wave(bullet_speed,spread_arc,step,wave_weights,bullet_weights)
	
func shoot_2():
	var bullet_speed = 400 
	var spread_arc = 6
	var step = 40	
	var wave_weights = [2,4]
	var bullet_weights = [1,2,2]	
	sonic_wave(bullet_speed,spread_arc,step,wave_weights,bullet_weights)
	
func sonic_wave(bullet_speed,spread_arc,step,wave_weights,bullet_weights):
	#=========================================
	# bullet_speed -> how fast is the base speed of the bullets
	# spread_arc -> how wide is the wave in degrees, the wave is double the spread_arc
	# step -> how long is the wave
	# wave_weights -> array 2x1
	# 		0 -> how dense is the first wave
	# 		1 -> how dense is the other waves
	# bullet_weights -> array 2x1
	# 		0 -> how random is the bullets direction
	# 		1 -> how random is the bullets speed
	# 		2 -> how much drag the bullets have	
	if velocity.x > bullet_speed:
		bullet_speed = bullet_speed/2+velocity.x
	if velocity.y > bullet_speed:
		bullet_speed = bullet_speed/2+velocity.y
	var bullet
	var shoot_direction = $Sprites/weapon_1/Muzzle.rotation
	var spread_rand
	for i in range(0,step):
		if i == 0:
			spread_rand= range(-spread_arc,spread_arc)
			for spread in spread_rand:
				for sub_spread in range(-wave_weights[0],wave_weights[0]):
					bullet = Bullet.instantiate()
					bullet.start($Sprites/weapon_1/Muzzle.global_position,
								 shoot_direction+deg_to_rad(spread+randfn(0,bullet_weights[0])),
								 bullet_speed+randfn(0,bullet_weights[1]),1)
					get_tree().root.add_child(bullet)				
			
		else:
			spread_rand= range(-spread_arc,spread_arc,int(i/wave_weights[1])+1)
			if len(spread_rand) == 1: 
				spread_rand.append(0)
			spread_rand.append(spread_arc)
			for spread in spread_rand:
				bullet = Bullet.instantiate()
				bullet.start($Sprites/weapon_1/Muzzle.global_position,
							 shoot_direction+deg_to_rad(spread+randfn(0,bullet_weights[0])),
							 bullet_speed+randfn(0,bullet_weights[1])*i/10,
							 i*bullet_weights[2])
				get_tree().root.add_child(bullet)

