extends CharacterBody2D

var max_speed
var hit_source
func start(_position, _direction,speed):
	
	rotation = _direction
	position = _position


	max_speed = speed
	velocity = Vector2(speed, 0).rotated(rotation)
	

func _physics_process(delta):

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(hit_source)


func _on_life_timeout():
	self.queue_free()
