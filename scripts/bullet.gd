extends Node3D

@export
var BulletSpeed : int

var BulletDirection : Vector3

func _ready():
	$Timer.connect("timeout", queue_free)
	$Timer.set_wait_time(3)
	$Timer.start()
	
func _process(delta):
	position += BulletDirection * BulletSpeed * delta
	print("bullet")
	print(BulletSpeed)
