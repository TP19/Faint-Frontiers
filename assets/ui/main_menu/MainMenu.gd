# Video Guide: https://youtu.be/LdHKs2Foon0?t=504
extends Control

func _ready():
	$Menu/Play.grab_focus()
	$Menu/Play.connect("pressed", self, "Play")
	$Menu/Options.connect("pressed", self, "Options")
	$Menu/Exit.connect("pressed", self, "Exit")
	if Input.is_action_pressed("menu"):
		MenuAudio.play()
		Global.get_tree().paused = false

func Play():
	#get_tree().change_scene("res://assets/ui/main_menu/Play.tscn")
	Transition.change_scenes("res://assets/ui/main_menu/Play.tscn")

func Options():
	#get_tree().change_scene("res://assets/ui/main_menu/Options.tscn")
	Transition.change_scenes("res://assets/ui/main_menu/Options.tscn")

func Exit():
	get_tree().quit()
