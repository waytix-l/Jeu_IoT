extends Camera3D

var shortscene = false

#func _physics_process(delta):
#
#	position = (get_parent().get_node("Player1").position + get_parent().get_node("Player2").position)/2
#	if (get_parent().get_node("Player1").position.x - get_parent().get_node("Player2").position.x > 500):
#		fov = 100
#		#position.x += (1.5 - position.x)/10
#	else :
#		fov = 75
#		#position.x += (1 - position.x)/10
