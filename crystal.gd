extends Area2D
var Bullet = preload("res://player/bullet.tscn")
var hit_cooldown = false
@onready var muzzle_aim = $Line2D




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = "static"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	body.name.contains("bullet")
	body.queue_free()
	if hit_cooldown == false:
		$AnimatedSprite2D.animation = "hit"
		$AnimatedSprite2D.play()
		hit_cooldown = true
		$cooldown.start()
		var bullet_speed = 150 
		var spread_arc = 90
		var step = 8	
		var wave_weights = [1,2]
		var bullet_weights = [4,10,15]	
		sonic_wave(bullet_speed,spread_arc,step,wave_weights,bullet_weights)


func _on_cooldown_timeout():
	hit_cooldown = false
	$AnimatedSprite2D.animation = "static"
	$AnimatedSprite2D.play()


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

	var bullet
	var shoot_direction = rotation - deg_to_rad(90)
	var spread_rand
	for i in range(0,step):		
		spread_rand= range(-spread_arc,spread_arc,int(i/wave_weights[1])+1)
		if len(spread_rand) == 1: 
			spread_rand.append(0)
		spread_rand.append(spread_arc)
		for spread in spread_rand:
			bullet = Bullet.instantiate()
			bullet.start(muzzle_aim.global_position,
						 shoot_direction+deg_to_rad(spread+randfn(0,bullet_weights[0])),
						 bullet_speed+4*randfn(0,bullet_weights[1])*(i+1)/10,
						 i*bullet_weights[2],"crystal")
			get_tree().root.call_deferred("add_child",bullet)



