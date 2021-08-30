extends Control

onready var LifeStat = $Camera2D/TextureRect
var health = LifeStat setget health_less_than

func health_less_than(value):
	health = value
	if (health == 100):
		hide()
	else: 
		if (health <= 50):
			show()
		else:
			hide()
		
func _ready():
	LifeStat = hide()
	health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "health_less_than")
