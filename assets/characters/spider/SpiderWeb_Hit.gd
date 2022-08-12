extends Area2D

func _process(delta):
	if Input.is_action_just_pressed("shield"):
		queue_free()

func _on_Spider_Web_area_entered(area):
	yield(get_tree().create_timer(0.2),"timeout")
	queue_free()
