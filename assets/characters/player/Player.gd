extends KinematicBody2D

export var ACCELERATION = 500
export var FRICTION = 360
export var MAX_SPEED = 100
export var ROLL_SPEED = 0.1

enum {
	MOVE,
	#ROLL,
	#ATTACK,
	#SHOOT,
	#DAMAGE,
	#SHIELD,
	#FREEZE,
	#DEATH
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO
var stats = PlayerStats
var motion = Vector2.ZERO
var screen_pos = Vector2()
var base_health = 5

onready var MainMenu = "res://assets/ui/main_menu/MainMenu.tscn"
onready var GameScore = "res://assets/ui/hud/GameOver.tscn"
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var SwordHitbox = $HitboxPivot/AttackRange
onready var hurtbox = $Hurtbox

# projectile variables
var projectile_scene = preload("res://assets/characters/player/PlayerProjectile.tscn")
onready var timer = get_node("TimerShoot")
onready var timer1 = get_node("Timer")


# defining conversion to isometric (and reverse for reference)
func cartesian_to_isometric(cartesian):
	screen_pos.x = cartesian.x - cartesian.y
	screen_pos.y = cartesian.x / 2 + cartesian.y / 2
	return screen_pos
	
func isometric_to_cartesian(iso):
	screen_pos.x = (iso.x + iso.y * 2) / 2
	screen_pos.y = iso.x + screen_pos.x
	return screen_pos
	
# this function will select which state should be executed
func _physics_process(delta):
	
	if Input.is_action_pressed("menu"):
		#MenuAudio.play()
		get_tree().change_scene(MainMenu)
		#Transition.change_scenes(MainMenu)
		
	match state:
		MOVE:
			move_state(delta)
	
#		ROLL:
#			roll_state(delta)
#			#velocity != Vector2.ZERO
#			velocity = roll_vector * MAX_SPEED * ROLL_SPEED
#
#		ATTACK:
#			attack_state(delta)
#			velocity = Vector2.ZERO
#
#		SHOOT:
#			shoot_state(delta)
#
#		DAMAGE:
#			damage_state(delta)
#
#		SHIELD:
#			shield_state(delta)
#
#		FREEZE:
#			animationState.travel("Idle")
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * 2000)
#			if Input.is_action_just_pressed("shield"):
#				state = SHIELD
#
#		DEATH:
#			death_state(delta)
#			velocity = Vector2.ZERO
			
#	if stats.health <= 25:
#		stats.health += 0.05
#		print(stats.health)
		
	if stats.health <= 0:
		stats.health += 10.05
		print(stats.health)
	
		
	if Global.elapsed_time <= 0:
		Global.elapsed_time = 0.017
		base_health()
		
		
func base_health():
	stats.health = base_health

# movement controlls and animations
func move_state(delta):
	var direction = Vector2()

	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)

	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	elif Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
	motion = direction.normalized() 
	motion = cartesian_to_isometric(motion).normalized()
	
	if motion != Vector2.ZERO:
		roll_vector = motion
		animationState.travel("Run")
		velocity = velocity.move_toward(screen_pos * MAX_SPEED, ACCELERATION * delta)
		animationTree.set("parameters/Run/blend_position", screen_pos)
		animationTree.set("parameters/Damage/blend_position", screen_pos)
		animationTree.set("parameters/Attack/blend_position", screen_pos)
		animationTree.set("parameters/Shoot/blend_position", screen_pos)
		animationTree.set("parameters/Idle/blend_position", screen_pos)
		animationTree.set("parameters/Roll/blend_position", screen_pos)
		animationTree.set("parameters/Shield/blend_position", screen_pos)
		animationTree.set("parameters/Death/blend_position", screen_pos)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()	
#	if Input.is_action_just_pressed("roll"):
#		state = ROLL
#		$dash.play()
#
#	if Input.is_action_just_pressed("attack"):
#		state = ATTACK
#
#	if Input.is_action_just_pressed("shield"):
#		state = SHIELD
#
#	if Input.is_action_just_pressed("shoot"):
#		state = SHOOT

# functions for each state
func roll_state(delta):
	animationState.travel("Roll")
	
	if velocity != Vector2.ZERO:	
		move()
	
	hurtbox.set_deferred("monitoring", false)
	$CollisionShape2D2.disabled = true
	yield(get_tree().create_timer(1), "timeout")
	$CollisionShape2D2.disabled = false
	hurtbox.set_deferred("monitoring", true)
			
#func attack_state(delta):
#	if stats.health <= 0:
#		state = DEATH
#	else:
#		animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	
func damage_state(delta):
	$Sprite.modulate = Color(2, 1, 1)
	#modulate.a8 = 200
	
#func shield_state(delta):
#	animationState.travel("Shield")
#	hurtbox.set_deferred("monitoring", false)
#	state = SHIELD
	
	if Input.is_action_just_pressed("shield"):	
		animationState.travel("Idle")
		state = MOVE
		yield(get_tree().create_timer(0.5), "timeout")
		hurtbox.set_deferred("monitoring", true)
		
func death_state(delta):
	animationState.travel("Death")
	
func shoot_state(delta):
	animationState.travel("Shoot")
	if timer.is_stopped():
		create_projectile()
		restart_timer()
		
	# Instantiate Projectile
func create_projectile():
		if motion != Vector2.ZERO:
			var projectile = projectile_scene.instance()
			projectile.global_position = get_node("Area2D/CollisionShape2D").global_position
			projectile.direction = motion
			get_parent().add_child(projectile)
		elif motion == Vector2.ZERO:
			var projectile = projectile_scene.instance()
			projectile.direction = motion
			#get_parent().add_child(projectile)

	# Add cooldown time to current shoot time		
func restart_timer():
	timer.set_wait_time(1)
	timer.start()
	timer.set_one_shot(true)

func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	
func show_score():
	print("Your Score: ", Global.points)
	
# behavior when the player gets damaged (when the enemy attacks player's $hurtbox) 
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	impact_slowdown(0.1, 0.5)
	stats.connect("health_changed", self, "damage_state" )
	print("Player HP: ", stats.health)
	
	yield(get_tree().create_timer(0.1),"timeout")
	animationPlayer.play("FLASH")
	
#	if state == SHIELD:
#		stats.health

#	if stats.health <= 0:
#		stats.connect("no_health", self, "death_state")
#		state = DEATH
#		yield(get_tree().create_timer(1),"timeout")
#		get_tree().change_scene(GameScore)
#		queue_free()
#		show_score()

		
#func _on_Area2D_area_entered(Spider_Web):
#	state = FREEZE
#
#func _on_Area2D2_area_entered(Spider_Web):
#	state = FREEZE

func impact_slowdown(time_scale, duration):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	Engine.time_scale = 1.0

# randomize the music everytime player is up for new game
# thanks https://www.youtube.com/watch?v=nIGJ6ImzSuI
func _ready():
	Global.points = 0
	Global.elapsed_time = 20
	
	
	var audioFiles = []
	audioFiles.append(preload("res://assets/music/skyline5.ogg"))
	audioFiles.append(preload("res://assets/music/8nine.ogg"))
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var a = AudioStreamPlayer.new()
	a.set_volume_db(linear2db(0.3))
	add_child(a)
	a.stream = audioFiles[rng.randi_range(0,1)]
	a.play()
