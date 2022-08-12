extends Label

func _process(delta):
	Global.get_tree().paused = true
	text = String(Global.elapsed_time)
	#yield(get_tree().create_timer(20), "timeout")
	if Input.is_action_pressed("menu"):
		MenuAudio.play()
		PlayerStats._ready()
		get_tree().change_scene("res://assets/ui/main_menu/MainMenu.tscn")
		Global.get_tree().paused = false
