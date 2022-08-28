extends Label

func _process(delta):
#	yield(get_tree().create_timer(0.1),"timeout")
	Global.get_tree().paused = true
	text = String(Global.elapsed_time)
	#yield(get_tree().create_timer(20), "timeout")
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			MenuAudio.play()
			PlayerStats._ready()
			get_tree().change_scene("res://assets/ui/main_menu/MainMenu.tscn")
			Global.get_tree().paused = false
