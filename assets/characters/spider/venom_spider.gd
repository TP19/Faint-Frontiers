extends KinematicBody2D

export var ACCELERATION = 10
export var MAX_SPEED = 20
export var WANDER_TARGET_RANGE = 2

var state = IDLE
onready var playerDetectionZone = $PlayerDetectionZone
onready var attackDetectionZone = $AttackDetectionZone
onready var sprite = $AnimationPlayer
onready var stats = $EnemyStats
onready var hurtbox = $Hurtbox
onready var animationTree = $AnimationTree
onready var wanderController = $WonderController
#onready var softCollisions = $SoftCollision
onready var animationState = animationTree.get("parameters/playback")
onready var timer = get_node("Timer")
#var web = preload("res://assets/characters/spider/SpiderWeb.tscn")
#var web_net = preload("res://assets/enemies/venom_spider/WebNet.tscn").instance()
#var spider_web = web.instance()
onready var spider = get_node("AnimationPlayer")

enum {
	IDLE,
	WANDER,
#	ATTACK,
#	SHOOT,
	CHASE
#	DEATH
}

var velocity = Vector2.ZERO
var screen_pos = Vector2()
				
func cartesian_to_isometric(cartesian):
	screen_pos.x = cartesian.x - cartesian.y
	screen_pos.y = cartesian.x / 2 + cartesian.y / 2
	return screen_pos

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	
	match state:
		IDLE: 
			animationState.travel("Idle")
			animationTree.set("parameters/Idle/blend_position", screen_pos)
			velocity = velocity.move_toward(Vector2.ZERO, 2000*delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
			animationState.travel("Run")
			animationTree.set("parameters/Run/blend_position", screen_pos)	
			accelerate_towards_point(wanderController.target_position, 0.1)
			
			if accelerate_towards_point(wanderController.target_position, delta) == 0:
				animationTree.set("parameters/Idle/blend_position", screen_pos)
				animationState.travel("Idle")
				velocity = velocity.move_toward(Vector2.ZERO, 2000*delta)
		
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
	
#		SHOOT:
#			var player = playerDetectionZone.player
#			if timer.is_stopped() and player != null:
#				animationTree.set("parameters/Shoot/blend_position", screen_pos)
#				animationState.travel("Shoot")
#				shoot_player(player.global_position, delta)
#				restart_timer()	
								
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				animationTree.set("parameters/Run/blend_position", screen_pos)
				animationState.travel("Run")
#				state = SHOOT

			elif player == null:
				velocity = velocity.move_toward(Vector2.ZERO, 2000*delta)
				state = IDLE

			yield(get_tree().create_timer(3),"timeout")
			update_wander()

			#seek_player_attack()
#
#		ATTACK:
#			var player = attackDetectionZone.player
#			seek_player_attack()
#
#			if player != null:
#				animationTree.set("parameters/Attack/blend_position", screen_pos)
#				animationState.travel("Attack")
#				attack_player(player.global_position, delta)
##			else:
##				state = SHOOT
#		DEATH:
#			animationTree.set("parameters/Death/blend_position", screen_pos)
#			animationState.travel("Death")
#			yield(get_tree().create_timer(0.3),"timeout")
#			queue_free()
#			Global.points += 10
#
#	if stats.health <= 0:
#		state = DEATH
		
#	if softCollisions.is_colliding():
#		velocity +=	softCollisions.get_push_vector() * delta * 30
#
	if Input.is_action_pressed("menu"):
		queue_free()

	velocity = move_and_slide(velocity)

#func shoot_animation_finished():
#	state = CHASE
	
func accelerate_towards_point(point, delta):
	var dir = position.direction_to(point) * 1
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * 1)
	dir = cartesian_to_isometric(velocity).normalized()

func attack_player(point, delta): 
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
	dir = cartesian_to_isometric(dir)	
	
#func shoot_player(point, delta):
#		spider_web.global_position = get_node("CollisionShape2D").global_position
#		spider_web.direction = global_position.direction_to(point)
#		get_tree().get_root().add_child(spider_web)
#		spider_web.show()
#		$shoot.play()
		
func restart_timer():
		timer.set_wait_time(3)
		timer.start()
		timer.set_one_shot(true)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
				
#func seek_player_attack():
#	if attackDetectionZone.can_see_player_attack():
#		state = ATTACK
		
func update_wander():
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if --area.damage:
		spider.play("FLASH")
		print("Venom Spider HP: ", stats.health)
			
func animation_finished():
	state = IDLE
