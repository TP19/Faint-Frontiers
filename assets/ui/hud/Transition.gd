extends CanvasLayer

export (String, FILE, "*.tscn") var target_scene
signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var black = $Display/Black
export (float) var fade_duration := 0.5
onready var tween = $Tween

#func _ready():
#
#
#	tween.interpolate_property(black, "modulate:a", 1, 0, fade_duration)
#	tween.interpolate_callback(black, fade_duration, "hide")
#	tween.start()

func change_scene(path := target_scene) -> void:
	#yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
#	assert(get_tree().change_scene(path) == OK)
	get_tree().change_scene(path)
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
	
	
#	black.show()
#	tween.interpolate_property(black, "modulate:a", 0, 1, fade_duration)
#	tween.start()
#	yield(tween, "tween_all_completed")
#	get_tree().change_scene(path)
