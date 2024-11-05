extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

@export var remote_camera: NodePath = NodePath("")

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
	WALK
}

var state: State = State.IDLE

func _ready() -> void:
	#print("remote camera", remote_camera)
	#remote_transform_2d.set_remote_node(remote_camera)
	pass

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

	if direction.length() == 0:
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

	if state == State.IDLE:
		if dir == Direction.BACK:
			animated_sprite.play("idle_back")
		elif dir == Direction.LEFT:
			animated_sprite.play("idle_right")
			animated_sprite.flip_h = true
		elif dir == Direction.RIGHT:
			animated_sprite.play("idle_right")
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("idle_front")
	elif state == State.WALK:
		if dir == Direction.BACK:
			animated_sprite.play("walk_back")
		elif dir == Direction.LEFT:
			animated_sprite.play("walk_right")
			animated_sprite.flip_h = true
		elif dir == Direction.RIGHT:
			animated_sprite.play("walk_right")
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("walk_front")
	
	velocity = direction.normalized() * SPEED

	move_and_slide()
