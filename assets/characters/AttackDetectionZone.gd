extends Area2D

var player = null

func can_see_player_attack():
	return player != null

func _on_AttackDetectionZone_body_entered(body):
	player = body

func _on_AttackDetectionZone_body_exited(body):
	player = null 
