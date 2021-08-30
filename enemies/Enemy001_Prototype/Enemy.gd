extends KinematicBody2D

export var ACCELERATION = 20
export var MAX_SPEED = 50

var state = IDLE
onready var playerDetectionZone = $PlayerDetectionZone
onready var attackDetectionZone = $AttackDetectionZone
onready var sprite = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var map_navigation = get_parent().get_node("World/Navigation2D")

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var screen_pos = Vector2()

func cartesian_to_isometric(cartesian):
	screen_pos.x = cartesian.x - cartesian.y
	screen_pos.y = cartesian.x / 2 + cartesian.y / 2
	return screen_pos

func _physics_process(delta):
	
	match state:
		IDLE: 
			animationTree.set("parameters/Idle/blend_position", screen_pos)
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
		WANDER:
			pass
			
			
		CHASE :
			animationState.travel("Run")
			animationTree.set("parameters/Run/blend_position", screen_pos)
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				
			else:
				state = IDLE
				
			seek_player_attack()
				
		ATTACK:
			animationState.travel("Attack")
			animationTree.set("parameters/Attack/blend_position", screen_pos)
			var player = attackDetectionZone.player
			if player != null:
				attack_player(player.global_position, delta)
			else:
				state = IDLE
				
	velocity = move_and_slide(velocity)
				
func accelerate_towards_point(point, delta):
	var dir = global_position.direction_to(point)

	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	dir = cartesian_to_isometric(velocity)
	
func attack_player(point, delta): 
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(dir * Vector2.ZERO, 100 * delta)
	dir = cartesian_to_isometric(dir)	
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
			
func seek_player_attack():
	if attackDetectionZone.can_see_player_attack():
		state = ATTACK

