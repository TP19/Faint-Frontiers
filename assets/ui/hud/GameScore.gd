extends Label

onready var MainMenu = "res://assets/ui/main_menu/MainMenu.tscn"

func _process(delta):
	text = String(Global.points)
	
	if Input.is_action_pressed("menu"):
		Transition.change_scene(MainMenu)
		PlayerStats._ready()
