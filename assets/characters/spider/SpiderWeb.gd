extends Area2D

var speed = 200
var direction = Vector2()
func _ready():
	set_process(true)

func _process(delta):
	position = position + speed * delta * direction

func _on_Spider_Web_area_entered(area):
	
	var web_net = preload("res://assets/characters/spider/WebNet.tscn")
	var hit = preload("res://assets/characters/spider/SpiderWeb_Hit.tscn").instance()
	get_parent().add_child(hit)
	hit.global_position = get_node("CollisionShape2D").global_position
	hide()
	var web_netto = web_net.instance()
	web_netto.transform = transform
	web_netto.global_position = get_node("CollisionShape2D").global_position
	yield(get_tree().create_timer(0.2),"timeout")
	get_parent().add_child(web_netto)
