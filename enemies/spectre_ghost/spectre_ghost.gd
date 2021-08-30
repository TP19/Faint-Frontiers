extends KinematicBody2D

export var ACCELERATION = 10
export var MAX_SPEED = 20
export var WANDER_TARGET_RANGE = 2
export var spectral_speed = 100

var state = IDLE
onready var playerDetectionZone = $PlayerDetectionZone
onready var attackDetectionZone = $AttackDetectionZone
onready var sprite = $AnimationPlayer
onready var stats = $EnemyStats
onready var hurtbox = $Hurtbox
onready var animationTree = $AnimationTree
onready var softCollisions = $SoftCollision
onready var wanderController = $WonderController
onready var animationState = animationTree.get("parameters/playback")
onready var timer = get_node("Timer")
var spectral_beam = preload("res://assets/enemies/spectre_ghost/Spectral_Beam.tscn").instance()
var beam = preload("res://assets/enemies/spectre_ghost/Spectral_Beam.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	DEATH
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
			accelerate_towards_point(wanderController.target_position, delta)
			
			if accelerate_towards_point(wanderController.target_position, delta) == 0:
				animationTree.set("parameters/Idle/blend_position", screen_pos)
				animationState.travel("Idle")
				velocity = velocity.move_toward(Vector2.ZERO, 2000*delta)
		
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE :
			animationState.travel("Attack")
			animationTree.set("parameters/Attack/blend_position", screen_pos)
			var player = playerDetectionZone.player
			if timer.is_stopped() and player and spectral_beam != null:
				shoot_player(player.global_position, delta)
				#spectral_beam.start_at(spectral_beam.direction, get_node("CollisionShape2D").global_position())
				restart_timer()
				
			elif player == null:
				spectral_beam.hide()
				state = IDLE
				
			seek_player_attack()
				
		ATTACK:
			var player = attackDetectionZone.player
			seek_player_attack()
	
			if player != null:
				animationTree.set("parameters/Attack/blend_position", screen_pos)
				animationState.travel("Attack")
				attack_player(player.global_position, delta)
			else:
				state = IDLE
				 
		DEATH:
			animationTree.set("parameters/Death/blend_position", screen_pos)
			animationState.travel("Death")
			yield(get_tree().create_timer(0.3),"timeout")
			queue_free()
			Global.points += 30
			
	if stats.health <= 0:
		state = DEATH
			
	if softCollisions.is_colliding():
		velocity +=	softCollisions.get_push_vector() * delta * 30
				
	velocity = move_and_slide(velocity)
	
func accelerate_towards_point(point, delta):
	var dir = position.direction_to(point) * ACCELERATION
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	dir = cartesian_to_isometric(velocity)

func attack_player(point, delta): 
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(Vector2.ZERO, 2000*delta)
	dir = cartesian_to_isometric(dir)	
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func shoot_player(point, delta):
	if spectral_beam != null:
		var player = playerDetectionZone.player
		var player_enemy = (spectral_beam.position - player.global_position)
		spectral_beam.global_position = get_node("CollisionShape2D").global_position
		spectral_beam.global_rotation = player_enemy.angle() + PI
		get_tree().get_root().add_child(spectral_beam)
		$shoot.play()
		
	if playerDetectionZone.player != null:
		spectral_beam.show()
	elif playerDetectionZone.player == null:
		spectral_beam.hide()
		beam.queue_free()
	else:
		spectral_beam.hide()
		
		
func restart_timer():
		timer.set_wait_time(3)
		timer.start()
		timer.set_one_shot(true)
				
func seek_player_attack():
	if attackDetectionZone.can_see_player_attack():
		state = ATTACK
		
func update_wander():
		#animationTree.set("parameters/Idle/blend_position", screen_pos)
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func damage_received(point, delta):
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
	dir = cartesian_to_isometric(dir)
	
func invincible():
	$Sprite.modulate = Color(1, 1, 1)
	modulate.a8 = 70
	hurtbox.set_deferred("monitoring", false)
	yield(get_tree().create_timer(6), "timeout")
	modulate.a8 = 255
	hurtbox.set_deferred("monitoring", true)
	
func _on_Hurtbox_area_entered(area):
		stats.health -= area.damage
			
		if --area.damage:
			$Sprite.modulate = Color(2, 1, 1)
			modulate.a8 = 255
			yield(get_tree().create_timer(0.1),"timeout")
			$Sprite.modulate = Color(1, 1, 1)
			print("Spectre Ghost HP: ", stats.health)
		
		if (stats.health <= 20 && stats.health >= 16):
			invincible()
			
func animation_finished():
	state = IDLE
