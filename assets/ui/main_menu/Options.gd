extends Control

func _ready():
	$Menu/Buttons/Return.grab_focus()
	$Menu/Buttons/Return.connect ("pressed", self, "Return")
	$Menu/Buttons/Audio.connect ("pressed", self, "Audio")
	$Menu/AudioSettings/MuteButton.connect ("pressed", self, "MuteButton")
	$Menu/Buttons/Video.connect ("pressed", self, "Video")
	$Menu/VideoSettings/FullscreenButton.connect ("pressed", self, "FullscreenButton")
	$Menu/Buttons/Controls.connect ("pressed", self, "Controls")
	pass

func Audio():
	$Menu/AudioSettings.show()
	$Menu/VideoSettings.hide()
	$Menu/ControlsSettings.hide()
	$Menu/Hint.hide()
	pass

var master_bus = AudioServer.get_bus_index("Master")
func _on_MuteButton_pressed():
	AudioServer.set_bus_mute(master_bus, not AudioServer.is_bus_mute(master_bus))

func Video():
	$Menu/AudioSettings.hide()
	$Menu/VideoSettings.show()
	$Menu/ControlsSettings.hide()
	$Menu/Hint.hide()
	pass

func _on_FullscreenButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func Controls():
	$Menu/AudioSettings.hide()
	$Menu/VideoSettings.hide()
	$Menu/ControlsSettings.show()
	$Menu/Hint.hide()
	pass

func Return():
	#get_tree().change_scene("res://assets/ui/main_menu/MainMenu.tscn")
	Transition.change_scene("res://assets/ui/main_menu/MainMenu.tscn")
	pass
