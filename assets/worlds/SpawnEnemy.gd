extends Node2D

#var Enemy=[preload("res://assets/enemies/venom_spider/VenomSpider.tscn"), preload("res://assets/enemies/spectre_ghost_lazer_god/SpectreGhost.tscn")]
#var arr = randi() % Enemy.size()
const spider = preload("res://assets/characters/spider/spider.tscn")
#const spectre = preload("res://assets/enemies/spectre_ghost_lazer_god/SpectreGhost.tscn")
var spawningarea = Rect2()
const Width = 150
const height = 100
var deltax1 = 3
var deltax2 = 20
var offset = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var spawningarea=Rect2(0,0,Width,height)
	set_next_spawn_spider()
#	set_next_spawn_spectre()
	
	# instance array
#	for i in arr:
#		var enemy = Enemy[arr].instance()
#		get_tree().get_root().add_child(enemy)
#		enemy.position = position
#		return position
	
func spawn_enemy_spider():
	
	var enemy1 = spider.instance()
	var position=Vector2(randi()%Width,randi()%height)
	get_tree().get_root().add_child(enemy1)	
	enemy1.position = position
	return position

#func spawn_enemy_spectre():
#	var enemy3 = spectre.instance()
#	var position=Vector2(randi()%Width,randi()%height)
#	get_tree().get_root().add_child(enemy3)
#	enemy3.position = position
#	return position
	
func set_next_spawn_spider():
	var next_time=deltax1+(randf()-0.5)*2*offset
	$Timer.wait_time=next_time
	$Timer.start()
	
#func set_next_spawn_spectre():
#	var next_time=deltax2+(randf()-0.5)*2*offset
#	$Timer2.wait_time=next_time
#	$Timer2.start()
	
func _on_Timer_timeout() -> void:
	spawn_enemy_spider()
	set_next_spawn_spider()

#func _on_Timer2_timeout():
##	spawn_enemy_spectre()
#	set_next_spawn_spectre()
