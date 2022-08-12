extends Node2D
#onready var audio = get_node(".GameAudio2") # load("res://assets/music/skyline5.ogg")])
#var  = load("res://assets/music/shoot.wav") # load("res://assets/music/skyline5.ogg")]
var points = 0
var elapsed_time = 0
#const Enemy=preload("res://assets/enemies/venom_spider/VenomSpider.tscn")
#var spawningarea = Rect2()
#const Width = 100
#const height = 100
#var delta = 2
#var offset = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuAudio.stop()
	# Called when the node enters the scene tree for the first time.

#	randomize()
#	var spawningarea=Rect2(0,0,Width,height)
#	set_next_spawn()
#
	#audio = audio_file #players[randi() % len(players)]
	#var bytes = audio_file.get_buffer(audio_file.get_len())
	#audio[0].play()
#	players.shuffle()
#	return players[0]
#	players[0].play()
			

#func load_ogg(file):
#	var path = "res://assets/music/%s.ogg" % file
#	var ogg_file = File.new()
#	ogg_file.open(path, File.READ)
#	var bytes = ogg_file.get_buffer(ogg_file.get_len())
#	var stream = AudioStreamOGGVorbis.new()
#	stream.data = bytes
#	$AudioStreamPlayer2D.stream = stream
#	ogg_file.close()
	
#func spawn_enemy():
#	var position=Vector2(randi()%Width,randi()%height)
#	var enemy=Enemy.instance()
#	$"..".add_child(enemy)
#	enemy.position = position
#	return position
#
#func set_next_spawn():
#	var next_time=delta+(randf()-0.5)*2*offset
#	$"../Timer".wait_time=next_time
#	$"../Timer".start()
#
#func _on_Timer_timeout() -> void:
#	spawn_enemy()
#	set_next_spawn()
	
func _process(delta):
	elapsed_time += 0.017
