extends CharacterBody2D
@export var drag = 0

func start(_position, _direction,speed,drag_factor):
	drag = drag_factor
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	velocity.x -= velocity.x*drag/2000
	velocity.y -= velocity.y*drag/2000
	if abs(velocity.x) < 50 && abs(velocity.y) < 50:
		self.queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()


func _on_life_timeout():
	self.queue_free()
