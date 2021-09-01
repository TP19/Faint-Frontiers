extends Area2D

var speed = 200
var direction = Vector2()
func _ready():
	set_process(true)

func _process(delta):
	position = position + speed * delta * direction

func _on_Spider_Web_area_entered(area):
	var web_net = preload("res://assets/enemies/snow_spider/Web_Net.tscn")
	var web_netto = web_net.instance()
	web_netto.transform = transform
	web_netto.global_position = get_node("CollisionShape2D").global_position
	get_parent().add_child(web_netto)
