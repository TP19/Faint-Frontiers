extends Node2D

const spider = preload("res://assets/characters/spider/spider.tscn")
var spawningarea = Rect2()
const Width = 150
const height = 100
var deltax1 = 3
var deltax2 = 20
var offset = 1

var num_enemies = 2
var num_enemies_left = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var spawningarea=Rect2(0,0,Width,height)
	#set_next_spawn_spider()
	spawn_enemy_spider()
	# instance array
#	for i in arr:
#		var enemy = Enemy[arr].instance()
#		get_tree().get_root().add_child(enemy)
#		enemy.position = position
#		return position
	
func spawn_enemy_spider():
	
	for i in num_enemies:
		var enemy1 = spider.instance()
		var position=Vector2(randi()%Width,randi()%height)
		enemy1.connect("enemy_destroyed", self, "_on_enemy_destroyed")
		get_tree().get_root().add_child(enemy1)
		num_enemies_left += 1      
		enemy1.position = position
		return position

func _on_enemy_destroyed():
	num_enemies_left -= 1
	if num_enemies_left <= 0:
		num_enemies += 2
		spawn_enemy_spider()

#func set_next_spawn_spider():
#	var next_time=deltax1+(randf()-0.5)*2*offset
#	$Timer.wait_time=next_time
#	$Timer.start()
#
#func _on_Timer_timeout() -> void:
#	var count_spider = get_tree().get_nodes_in_group("spider")
#	if len(count_spider) > 4:
#		pass
#	else:
#		spawn_enemy_spider()
#		set_next_spawn_spider()
