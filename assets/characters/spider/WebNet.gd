extends Node2D

var speed = 800
export var damage = 0
var direction = Vector2()

func _ready():
	set_process(true)

func _process(delta):
	$AnimatedSprite.play("default")
	if Input.is_action_just_pressed("shield"):
		queue_free()

#	position = position + speed * delta * direction
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "default":
		$AnimatedSprite.stop()
