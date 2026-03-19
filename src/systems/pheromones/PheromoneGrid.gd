class_name PheromoneGrid
extends Node

enum Type { HOME, FOOD, DANGER }

var _width: int
var _height: int
var _grids: Array[PackedFloat32Array]

func _ready() -> void:
	_width  = ceili(Constants.WORLD_WIDTH  / float(Constants.GRID_CELL_SIZE))
	_height = ceili(Constants.WORLD_HEIGHT / float(Constants.GRID_CELL_SIZE))

	_grids = []
	for i in Type.size():
		_grids.append(PackedFloat32Array())
		_grids[i].resize(_width * _height)
		_grids[i].fill(0.0)

func _process(delta: float) -> void:
	evaporate(delta)

func read(type: Type, cell: Vector2i) -> float:
	if not _in_bounds(cell):
		return 0.0
	return _grids[type][_index(cell)]

func write(type: Type, cell: Vector2i, value: float) -> void:
	if not _in_bounds(cell):
		return
	_grids[type][_index(cell)] = clampf(value, 0.0, Constants.PHEROMONE_MAX_STRENGTH)

func add(type: Type, cell: Vector2i, amount: float) -> void:
	write(type, cell, read(type, cell) + amount)

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(world_pos.x / Constants.GRID_CELL_SIZE),
		floori(world_pos.y / Constants.GRID_CELL_SIZE)
	)

func evaporate(delta: float) -> void:
	var decay := Constants.PHEROMONE_EVAPORATION_RATE * delta
	for grid in _grids:
		for i in grid.size():
			grid[i] = maxf(0.0, grid[i] - decay)

func _in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < _width and cell.y >= 0 and cell.y < _height

func _index(cell: Vector2i) -> int:
	return cell.y * _width + cell.x
