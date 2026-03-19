class_name AntBase
extends Node2D

enum State { EXPLORING, RETURNING }

const NEIGHBOR_OFFSETS := [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1,  0),                  Vector2i(1,  0),
	Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
]

var _state: State = State.EXPLORING
var _grid: PheromoneGrid
var _current_cell: Vector2i
var _emit_timer: float = 0.0

func setup(grid: PheromoneGrid) -> void:
	_grid = grid
	_current_cell = _grid.world_to_cell(global_position)

func _process(delta: float) -> void:
	_step()
	_emit_timer += delta
	if _emit_timer >= Constants.PHEROMONE_EMIT_INTERVAL:
		_emit_pheromone()
		_emit_timer = 0.0

func _step() -> void:
	var target_cell := _weighted_neighbor()
	_current_cell = target_cell
	global_position = Vector2(
		_current_cell.x * Constants.GRID_CELL_SIZE + Constants.GRID_CELL_SIZE * 0.5,
		_current_cell.y * Constants.GRID_CELL_SIZE + Constants.GRID_CELL_SIZE * 0.5
	)

func _weighted_neighbor() -> Vector2i:
	var best_cell := _current_cell
	var best_score := -1.0

	for offset in NEIGHBOR_OFFSETS:
		var cell: Vector2i = _current_cell + offset
		if not is_walkable(cell):
			continue
		var pheromone_type := PheromoneGrid.Type.FOOD if _state == State.EXPLORING else PheromoneGrid.Type.HOME
		var score := _grid.read(pheromone_type, cell) + randf() * Constants.ANT_RANDOM_WEIGHT
		if score > best_score:
			best_score = score
			best_cell = cell

	return best_cell

func _emit_pheromone() -> void:
	var pheromone_type := PheromoneGrid.Type.HOME if _state == State.EXPLORING else PheromoneGrid.Type.FOOD
	_grid.add(pheromone_type, _current_cell, Constants.PHEROMONE_EMIT_AMOUNT)

func is_walkable(cell: Vector2i) -> bool:
	# Stub — always true until WorldGrid is implemented in Jalon 2
	return _grid._in_bounds(cell)
