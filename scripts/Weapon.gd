extends Node3D

@export
var BulletPrefab : PackedScene

@export
var rootNode : Node3D

@export
var shootPosition : Node3D

@export
var fireRate : float

var fireTimer : float

# Called when the node enters the scene tree for the first time.   
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):  
	
	if fireTimer < fireRate :
		fireTimer += delta
	
	if Input.is_action_pressed("shoot") and fireTimer >= fireRate :
		fireTimer = 0
		var Bullet = BulletPrefab.instantiate()
		rootNode.add_child(Bullet)
		Bullet.position = shootPosition.global_position
		
		Bullet.BulletDirection = get_parent().PlayerAngle
		Bullet.BulletSpeed = 10
		
	pass
