extends Control

func _ready():
	$LevelSelection/TopRow/LevelOne/Cover.grab_focus()
	$LevelSelection/TopRow/LevelOne/Cover.connect("pressed", self, "Classic")
	$LevelSelection/TopRow/LevelTwo/Cover/.connect("pressed", self, "Survival")
	$Return.connect("pressed", self, "Return")

func Classic():
	#get_tree().change_scene("res://assets/worlds/World.tscn")
	Transition.change_scenes("res://assets/worlds/World.tscn")

func Survival():
	pass
	
func Return():
	#get_tree().change_scene("res://assets/ui/main_menu/MainMenu.tscn")
	Transition.change_scenes("res://assets/ui/main_menu/MainMenu.tscn")
