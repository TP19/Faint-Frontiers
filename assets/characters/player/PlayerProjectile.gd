extends Area2D

var speed = 300
export var damage = 5
var direction = Vector2()

func _ready():
	set_process(true)

func _process(delta):
	position = position + speed * delta * direction

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
