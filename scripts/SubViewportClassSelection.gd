extends SubViewport

var window_size

var class_index = 0

var class_locked = false
var bonus_locked = false

@export var selector: MeshInstance3D

@warning_ignore("shadowed_global_identifier")
@export var Player: PackedScene

@export var LEFT = "ui_left"
@export var RIGHT = "ui_right"
@export var SELECT = "ui_select"

@onready var bonus_screen = $Bonus_Screen

func _ready():
	#window_size = DisplayServer.screen_get_size(0)
	window_size = get_window().get_size_with_decorations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	window_size = get_window().get_size_with_decorations()
	size.x = window_size.x / 2
	size.y = window_size.y
	
	if !class_locked:
		if Input.is_action_just_pressed(LEFT):
			if class_index == 0:
				class_index = 2
			else :
				class_index -= 1
		if Input.is_action_just_pressed(RIGHT):
			if class_index == 2:
				class_index = 0
			else :
				class_index += 1
	
	if Input.is_action_just_pressed(SELECT):
		class_locked = true
		bonus_screen.visible = true
		selector.scale = Vector3(0.5, 1, 0.5)
		if class_index == 0:
			Player.set_script("Archer.gd")
		elif class_index == 1:
			Player.set_script("Assassin.gd")
		elif class_index == 2:
			Player.set_script("Tank.gd")
	
	#if class_locked:
		#bonus_screen.visible = true
	
	match class_index:
		0:
			selector.position = Vector3(-2.5, 3, 0)
		1:
			selector.position = Vector3(0, 3, -0.5)
		2:
			selector.position = Vector3(2.5, 3, 0)
	
	
	
