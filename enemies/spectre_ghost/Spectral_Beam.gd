extends Area2D

var speed = 100
export var damage = 40
var direction = Vector2()
var player = "res://assets/player/Player002.tscn"
var velocity = direction.normalized()

func _ready():
	set_process(true)
	
func _process(delta):
	position = position + speed * velocity * delta
	$AnimatedSprite.play("beam")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "beam":
		$AnimatedSprite.stop()

func _on_Spectral_Beam_area_exited(area):
		area.hide()

func _on_Spectral_Beam_area_entered(area):
		show()

func _on_Spectral_Beam_body_exited(body):
	hide()
