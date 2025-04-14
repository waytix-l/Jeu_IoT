extends ColorRect

var window_size

func _ready():
	pass

func _process(delta):
	window_size = get_window().get_size_with_decorations()
	size.x = window_size.x
	size.y = window_size.y
