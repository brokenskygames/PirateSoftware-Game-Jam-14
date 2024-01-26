extends Node2D

func _ready():
	$Baseplate.visible = true
	$Shotgun.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _shotgun():
	$Shotgun.visible = true
	$Sniper.visible = false
	
func _sniper():
	$Sniper.visible = true
	$Shotgun.visible = false
