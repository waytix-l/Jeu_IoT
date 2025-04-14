extends SubViewport

var window_size

func _ready():
	window_size = get_window().get_size_with_decorations()

@warning_ignore("unused_parameter")
func _process(delta):
	window_size = get_window().get_size_with_decorations()
	size.x = window_size.x / 2
	size.y = window_size.y
