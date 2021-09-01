extends KinematicBody2D

export var ACCELERATION = 500
export var FRICTION = 500
export var MAX_SPEED = 40
export var ROLL_SPEED = 0.1

enum {
	MOVE,
	ROLL,
	ATTACK,
	SHOOT,
	DAMAGE,
	SHIELD,
	FREEZE,
	DEATH
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO
var stats = PlayerStats
var motion = Vector2.ZERO
var screen_pos = Vector2()

onready var MainMenu = "res://assets/ui/main_menu/MainMenu.tscn"
onready var GameScore = "res://assets/ui/hud/Game_Over.tscn"
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var SwordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

# projectile variables
var projectile_scene = preload("res://assets/player/Player_Projectile.tscn")
onready var timer = get_node("Timer_Shoot")
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
		get_tree().change_scene(MainMenu)
		
	match state:
		MOVE:
			move_state(delta)
	
		ROLL:
			roll_state(delta)
			velocity != Vector2.ZERO
			
		ATTACK:
			attack_state(delta)
			velocity = Vector2.ZERO
			
		SHOOT:
			shoot_state(delta)

		DAMAGE:
			damage_state(delta)

		SHIELD:
			shield_state(delta)
			
		FREEZE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * 2000)
			if Input.is_action_just_pressed("shield"):
				state = SHIELD
			
		DEATH:
			death_state(delta)
			velocity = Vector2.ZERO
			
	if Global.points == 120:
		get_tree().change_scene("res://assets/ui/hud/Game_Score.tscn")

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
	if Input.is_action_just_pressed("roll"):
		state = ROLL
			
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("shield"):
		state = SHIELD
		
	if Input.is_action_just_pressed("shoot"):
		state = SHOOT

# functions for each state
func roll_state(delta):
	velocity = roll_vector * MAX_SPEED * ROLL_SPEED
	animationState.travel("Roll")
	$Sprite.modulate = Color(1, 1, 1)
	if velocity != Vector2.ZERO:	
		move()
	else:
		animationState.travel("Idle")
		state = MOVE
	
	hurtbox.set_deferred("monitoring", false)
	$CollisionShape2D2.disabled = true
	yield(get_tree().create_timer(1), "timeout")
	$CollisionShape2D2.disabled = false
	hurtbox.set_deferred("monitoring", true)
			
func attack_state(delta):
	if stats.health <= 0:
		state = DEATH
	else:
		animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	
func damage_state(delta):
	$Sprite.modulate = Color(2, 1, 1)
	modulate.a8 = 200
	
func shield_state(delta):
	animationState.travel("Shield")
	hurtbox.set_deferred("monitoring", false)
	state = SHIELD
	
	if Input.is_action_just_pressed("shield"):	
		animationState.travel("Idle")
		hurtbox.set_deferred("monitoring", true)
		state = MOVE
		
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
		else:
			var projectile = projectile_scene.instance()
			projectile.direction = motion

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
	stats.connect("health_changed", self, "damage_state" )
	print("Player HP: ", stats.health)
	
	yield(get_tree().create_timer(0.1),"timeout")
	$Sprite.modulate = Color(1, 1, 1)
	modulate.a8 = 255
	
	if stats.health <= 0:
		stats.connect("no_health", self, "death_state")
		state = DEATH
		yield(get_tree().create_timer(1),"timeout")
		get_tree().change_scene(GameScore)
		queue_free()
		show_score()
	else:
		hurtbox.set_deferred("monitoring", false)
		yield(get_tree().create_timer(3), "timeout")
		hurtbox.set_deferred("monitoring", true)
		
func _on_Area2D_area_entered(Spider_Web):
	state = FREEZE

func _on_Area2D2_area_entered(Spider_Web):
	state = FREEZE
