extends Node3D

@export var SubViewportPlayer1: SubViewport
@export var SubViewportPlayer2: SubViewport

var world_scene = load("res://world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if SubViewportPlayer1.get("class_locked") and SubViewportPlayer2.get("class_locked"):
		get_tree().change_scene_to_packed(world_scene)
