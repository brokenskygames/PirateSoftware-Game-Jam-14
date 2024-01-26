extends CharacterBody2D
var Bullet = preload("res://player/bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var stop = false
var aiming = false
@export var weapon = 1
@onready var muzzle_aim = $Sprites/weapon_1/Muzzle_1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$Sprites/weapon_1.visible = false
	$Sprites/weapon_2.visible = false
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
		if aiming == false:
			$AnimatedSprite2D.animation = "idle"	
	move_and_slide()
	if velocity.x < -0.1:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0.1:
		$AnimatedSprite2D.flip_h = false
	
	
	if dir.length() > 5:
		$Sprites/weapon_1.rotation = dir.angle()
		$Sprites/weapon_2.rotation = dir.angle()
		muzzle_aim.rotation = dir.angle()

	
func get_input():
	var weapon_aim = $Sprites/weapon_1
	var muzzle_aim = $Sprites/weapon_1/Muzzle_1
	
	if Input.is_action_pressed("change1"):
		weapon = 1 
		muzzle_aim = $Sprites/weapon_1/Muzzle_1
		
	if Input.is_action_pressed("change2"):
		weapon = 2
		muzzle_aim = $Sprites/weapon_2/Muzzle_2
		
	if Input.is_action_pressed("alt_shoot"):
		stop = true
		aiming = true
		$AnimatedSprite2D.animation = "aim"
		$AnimatedSprite2D.play()
		if weapon == 1:
			$Sprites/weapon_1.visible = true
			$Sprites/weapon_2.visible = false
			weapon_aim = $Sprites/weapon_1
		elif weapon == 2:			
			$Sprites/weapon_1.visible = false
			$Sprites/weapon_2.visible = true
			weapon_aim = $Sprites/weapon_2
		var shoot_direction = rad_to_deg(muzzle_aim.rotation)
		if shoot_direction > -90 and shoot_direction < 90:
			velocity.x = 0
			$AnimatedSprite2D.flip_h = false
			weapon_aim.flip_h = false
			weapon_aim.flip_v = false
		else: 
			velocity.x = 0
			$AnimatedSprite2D.flip_h = true
			weapon_aim.flip_h = false
			weapon_aim.flip_v = true
		if Input.is_action_just_pressed("shoot"):
			if weapon == 1: 
				shoot_1()
			elif weapon == 2: 
				shoot_2()
			
	else:
		stop = false
		aiming = false
		

func shoot_1():
	var bullet_speed = 200 
	#var spread_arc = 20
	#var step = 30	
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
	var shoot_direction = muzzle_aim.rotation
	var spread_rand
	for i in range(0,step):
		if i == 0:
			spread_rand= range(-spread_arc,spread_arc)
			for spread in spread_rand:
				for sub_spread in range(-wave_weights[0],wave_weights[0]):
					bullet = Bullet.instantiate()
					bullet.start(muzzle_aim.global_position,
								 shoot_direction+deg_to_rad(spread+randfn(0,bullet_weights[0])),
								 bullet_speed+randfn(0,bullet_weights[1]),1,"player")
					get_tree().root.add_child(bullet)				
			
		else:
			spread_rand= range(-spread_arc,spread_arc,int(i/wave_weights[1])+1)
			if len(spread_rand) == 1: 
				spread_rand.append(0)
			spread_rand.append(spread_arc)
			for spread in spread_rand:
				bullet = Bullet.instantiate()
				bullet.start(muzzle_aim.global_position,
							 shoot_direction+deg_to_rad(spread+randfn(0,bullet_weights[0])),
							 bullet_speed+randfn(0,bullet_weights[1])*i/10,
							 i*bullet_weights[2],"player")
				get_tree().root.add_child(bullet)

