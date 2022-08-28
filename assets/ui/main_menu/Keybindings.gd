extends Node

onready var settingsmenu = load("res://assets/ui/main_menu/ControlsMenu.tscn")
var filepath = "res://assets/ui/main_menu/keybindings.ini"
var configfile

var keybinds = {}

#func _input(event):
	#if Input.is_key_pressed(KEY_ESCAPE):
		#add_child(settingsmenu.instance())
		#get_tree().paused = true

func _ready():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybindings"):
			var key_value = configfile.get_value("keybindings", key)
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		print("ERROR: CONFIGURATION FILE NOT FOUND!")
		#get_tree().quit()
	
	set_game_binds()

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybindings", key, key_value)
		else:
			configfile.set_value("keybindings", key, "")
	configfile.save(filepath)
