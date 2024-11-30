extends CharacterBody2D

# @onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var animation_tree: AnimationTree = $AnimationTree

@export var remote_camera: Camera2D

const SPEED = 120.0

var direction: Vector2 = Vector2(0, 0)

enum Direction {
	LEFT = 0,
	RIGHT,
	BACK,
	FRONT
}

var dir: Direction = Direction.FRONT

enum State {
	IDLE,
	WALK,
	ATTACK
}

var state: State = State.IDLE

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if Input.is_action_just_released("attack"):
		state = State.ATTACK
	elif direction.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK
		if direction.x < 0:
			dir = Direction.LEFT
		elif direction.x > 0:
			dir = Direction.RIGHT

		if direction.y < 0:
			dir = Direction.BACK
		elif direction.y > 0:
			dir = Direction.FRONT

	var animation_blend_position = Vector2(0, 1)
	match dir:
		Direction.BACK:
			animation_blend_position = Vector2(0, -1)
		Direction.LEFT:
			animation_blend_position = Vector2(-1, 0)
		Direction.RIGHT:
			animation_blend_position = Vector2(1, 0)

	# set blend_positions
	animation_tree.set("parameters/Idle/blend_position", animation_blend_position)
	animation_tree.set("parameters/Walk/BlendSpace2D/blend_position", animation_blend_position)
	animation_tree.set("parameters/Attack/BlendSpace2D/blend_position", animation_blend_position)
	
	# set animation conditioas
	animation_tree.set("parameters/conditions/idle", state == State.IDLE)
	animation_tree.set("parameters/conditions/walk", state == State.WALK)
	animation_tree.set("parameters/conditions/attack", state == State.ATTACK)
	
	velocity = direction.normalized() * SPEED

	move_and_slide()
