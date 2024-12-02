@tool
extends Node2D


@export var grid_center := Vector2(0, 0)

@export var grid_size := Vector2(32, 32)
@export var cell_size: int = 16
@export var grid_gap: float = 0
@export var grid_fill_gap: float = 1

var grid_start: Vector2

var player_cell_index: Vector2
var player_cell: Polygon2D

var enemy_cell_index: Vector2
var enemy_cell: Polygon2D

func _init():
	grid_start = Vector2(grid_size.x * cell_size / 2, grid_size.y * cell_size / 2)

func _ready():
	pass
	
func add_player_cell(pos: Vector2):
	player_cell = _create_cell("PlayerCell", Color(Color.DEEP_SKY_BLUE, .5))
	update_player_cell(pos)
	add_child(player_cell)

func update_player_cell(pos: Vector2):
	var player_grid_pos := Vector2(pos + grid_start)
	player_cell_index = Vector2(floor(player_grid_pos / cell_size))
	var start := Vector2(player_cell_index * cell_size - grid_start)
	player_cell.set_polygon(PackedVector2Array([
		start + Vector2(grid_fill_gap, grid_fill_gap),
		Vector2(start.x + cell_size - grid_fill_gap, start.y + grid_fill_gap),
		Vector2(start.x + cell_size - grid_fill_gap, start.y + cell_size - grid_fill_gap),
		Vector2(start.x + grid_fill_gap, start.y + cell_size - grid_fill_gap)
	]))
	
func add_enemy_cell(pos: Vector2):
	enemy_cell = _create_cell("EnemyCell", Color(Color.RED, .5))
	update_enemy_cell(pos)
	add_child(enemy_cell)
	
func update_enemy_cell(pos: Vector2):
	var enemy_grid_pos := Vector2(pos + grid_start)
	enemy_cell_index = Vector2(floor(enemy_grid_pos / cell_size))
	var start := Vector2(enemy_cell_index * cell_size - grid_start)
	enemy_cell.set_polygon(PackedVector2Array([
		start + Vector2(grid_fill_gap, grid_fill_gap),
		Vector2(start.x + cell_size - grid_fill_gap, start.y + grid_fill_gap),
		Vector2(start.x + cell_size - grid_fill_gap, start.y + cell_size - grid_fill_gap),
		Vector2(start.x + grid_fill_gap, start.y + cell_size - grid_fill_gap)
	]))

func _create_cell(name: String, color: Color) -> Polygon2D:
	var cell := Polygon2D.new()
	cell.set_name(name)
	cell.set_color(color)
	
	return cell
	
func _draw():
	for i in range(grid_size.x):
		for j in range(grid_size.y):
			var color: Color
			if i == 0 and j == 0:
				color = Color.RED
			elif Vector2(i, j) == Vector2(grid_size.x - 1, grid_size.y - 1):
				color = Color.GREEN
			else:
				color = Color.WHITE

			draw_rect(
				Rect2(
					Vector2(i * cell_size - (grid_gap / 2) - grid_start.x, j * cell_size - (grid_gap / 2) - grid_start.y), 
					Vector2(cell_size - grid_gap, cell_size - grid_gap)
					), color, false, .5)
