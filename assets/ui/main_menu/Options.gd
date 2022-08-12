extends Control

func _ready():
	$Return.grab_focus()
	$Buttons/Audio.connect ("pressed", self, "Audio")
	$Buttons/Video.connect ("pressed", self, "Video")
	$Buttons/Controls.connect ("pressed", self, "Controls")
	$Return.connect ("pressed", self, "Return")
	pass
	
func Audio():
	pass
	
func Video():
	pass

func Controls():
	pass

func Return():
	#get_tree().change_scene("res://assets/ui/main_menu/MainMenu.tscn")
	Transition.change_scenes("res://assets/ui/main_menu/MainMenu.tscn")
	pass
