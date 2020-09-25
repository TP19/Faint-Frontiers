extends KinematicBody2D


export var ACCELERATION = 200
export var FRICTION = 10
export var MAX_SPEED = 120
export var ROLL_SPEED = 1.5

enum { 
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var motion = Vector2.ZERO
var screen_pos = Vector2()
var state = MOVE
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func cartesian_to_isometric(cartesian):
	screen_pos.x = cartesian.x - cartesian.y
	screen_pos.y = cartesian.x / 2 + cartesian.y / 2
	return screen_pos
	
#func _ready():
#	animationTree.active = true

func _physics_process(delta):
	#move_state(delta)

	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
			velocity = Vector2.ZERO
			
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
	motion = cartesian_to_isometric(motion)
	
	
	if motion != Vector2.ZERO:
		roll_vector = motion
		animationTree.set("parameters/Idle/blend_position", screen_pos)
		animationTree.set("parameters/Run/blend_position", screen_pos)
		animationTree.set("parameters/Attack/blend_position", screen_pos)
		animationTree.set("parameters/Roll/blend_position", screen_pos)
		animationState.travel("Run")
		velocity = velocity.move_toward(motion * MAX_SPEED, ACCELERATION * delta)
		
		print(velocity)

	else:
		animationState.travel("Idle")
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity = Vector2.ZERO
	
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
func roll_state(delta):
	velocity = roll_vector * MAX_SPEED * ROLL_SPEED
	animationState.travel("Roll")
	move()
		
func attack_state(delta):
	motion = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_animation_finished():	
	 state = MOVE
	
func move():
	velocity = move_and_slide(velocity)	
	
func attack_animation_finished():
	state = MOVE
	


