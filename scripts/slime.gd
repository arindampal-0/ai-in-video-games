extends CharacterBody2D

@export var player: CharacterBody2D

var SPEED = 50.0
var MIN_DISTANCE = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if global_position.distance_to(player.global_position) > MIN_DISTANCE:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
