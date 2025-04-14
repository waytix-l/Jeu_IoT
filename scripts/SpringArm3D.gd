extends SpringArm3D

@export
var Player : Node3D

@export
var Player2 : Node3D

var DistanceBetweenPlayers : float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	DistanceBetweenPlayers = sqrt((Player2.position.x - Player.position.x)**2 + (Player2.position.y - Player.position.y)**2 + (Player2.position.z - Player.position.z)**2)
	
	position = ((Player.position + Player2.position) / 2) + (Vector3.UP * DistanceBetweenPlayers * 0.2 + Vector3.BACK * 20 + Vector3.RIGHT * 5)
	
	print(sqrt((Player2.position.x - Player.position.x)**2 + (Player2.position.y - Player.position.y)**2 + (Player2.position.z - Player.position.z)**2))
	
	
