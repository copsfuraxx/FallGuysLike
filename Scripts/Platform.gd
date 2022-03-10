extends KinematicBody

var joueur = null
var velocite = Vector3.ZERO

func _process(delta):
	if(joueur != null && joueur.is_on_floor()):
		var vector = joueur.translation - get_parent().translation
		var distance = sqrt(vector.x * vector.x + vector.z * vector.z) / 2
		vector.z = vector.z * distance * delta * PI/15
		vector.x = -vector.x * distance * delta * PI/15
		velocite.z = vector.x
		velocite.x = vector.z
	if(rotation.z + velocite.z < PI/9 && rotation.z + velocite.z > -PI/9):
		rotate_z(velocite.z)
	elif rotation.z + velocite.z > PI/9:
		rotation.z = PI/9
	else:
		rotation.z = -PI/9
	if(rotation.x + velocite.x < PI/9 && rotation.x + velocite.x > -PI/9):
		rotate_x(velocite.x)
	elif rotation.x + velocite.x > PI/9:
		rotation.x = PI/9
	else:
		rotation.x = -PI/9

func _on_Area_body_entered(body):
	joueur = body


func _on_Area_body_exited(_body):
	joueur = null
