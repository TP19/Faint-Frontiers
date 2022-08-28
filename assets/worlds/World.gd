extends Node2D
var points = 0
var elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuAudio.stop()
	
func _process(delta):
	elapsed_time += 0.017
