extends Area


func _on_CheckPoint_body_entered(body):
	body._on_CheckPoint_body_entered(get_parent().translation)
