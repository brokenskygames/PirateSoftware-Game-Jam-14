extends CharacterBody2D
@export var drag = 0

var array_color = ["C7C093","B3A286","85917A","5C7873","466673","3A4A6B","302C5E"]
var max_speed
var hit_source
func start(_position, _direction,speed,drag_factor,source):
	
	
	drag = drag_factor
	hit_source = source
	modulate = Color("C7C093")
	rotation = _direction
	if source == "crystal":
		position = _position + 0.04*_position.rotated(rotation)
		$life.wait_time = 1.5
	elif source == "shoot_1": 
		position = _position
		$life.wait_time = 1.5
	else: 
		position = _position
		$life.wait_time = 3
	

	max_speed = speed
	velocity = Vector2(speed, 0).rotated(rotation)
	

func _physics_process(delta):
	if velocity.length() > 11*max_speed/12:
		modulate = Color("302C5E")
	elif velocity.length() > 10*max_speed/12:
		modulate = Color("3A4A6B")
	elif velocity.length() > 8*max_speed/12:
		modulate = Color("466673")
	elif velocity.length() > 6*max_speed/12:
		modulate = Color("5C7873")
	elif velocity.length() > 4*max_speed/12:
		modulate = Color("85917A")
	elif velocity.length() > 2*max_speed/12:
		modulate = Color("B3A286")
	elif velocity.length() < 2*max_speed/12:
		modulate = Color("C7C093")
	velocity.x -= velocity.x*drag/2000
	velocity.y -= velocity.y*drag/2000
	if abs(velocity.x) < 50 && abs(velocity.y) < 50:
		self.queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(hit_source)

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()


func _on_life_timeout():
	self.queue_free()
