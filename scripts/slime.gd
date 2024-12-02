extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var player: CharacterBody2D
@export var grid: Node2D
@export var follow_player: bool = true
@export var min_distance: float = 50.0
@export var speed: float = 50.0

enum SlimeState {
	IDLE = 0,
	WALK,
	CHASE
}

enum Direction {
	LEFT = 0,
	RIGHT,
	BACK,
	FRONT,
}

var state: SlimeState = SlimeState.IDLE
var dir: Direction = Direction.FRONT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(player)
	grid.call("add_enemy_cell", position)

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if follow_player && global_position.distance_to(player.global_position) > min_distance:
		velocity = direction * speed
		
		if direction.x < 0:
			dir = Direction.LEFT
		elif direction.x > 0:
			dir = Direction.RIGHT

		if direction.y < 0:
			dir = Direction.BACK
		elif direction.y > 0:
			dir = Direction.FRONT
		
		state = SlimeState.CHASE
	else:
		velocity = Vector2.ZERO
		state = SlimeState.IDLE
		
	if state == SlimeState.IDLE:
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
	elif state == SlimeState.CHASE:
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
	
	move_and_slide()
	
	grid.call("update_enemy_cell", position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
