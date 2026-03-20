class_name PheromoneGrid
extends Node2D

enum Type { SEARCH, RETURN }

var _width: int
var _height: int
var _grids: Array[PackedVector2Array]

func _ready() -> void:
	_width  = ceili(Constants.WORLD_WIDTH  / float(Constants.GRID_CELL_SIZE))
	_height = ceili(Constants.WORLD_HEIGHT / float(Constants.GRID_CELL_SIZE))

	_grids = []
	for i in Type.size():
		var arr := PackedVector2Array()
		arr.resize(_width * _height)
		arr.fill(Vector2.ZERO)
		_grids.append(arr)

func _process(delta: float) -> void:
	evaporate(delta)
	# queue_redraw()  # uncomment to enable pheromone debug view

func deposit(type: Type, cell: Vector2i, velocity: Vector2) -> void:
	if not _in_bounds(cell):
		return
	var idx := _index(cell)
	var current: Vector2 = _grids[type][idx]
	current += velocity
	if current.length() > 1.0:
		current = current.normalized()
	_grids[type][idx] = current

func read_vector(type: Type, cell: Vector2i) -> Vector2:
	if not _in_bounds(cell):
		return Vector2.ZERO
	return _grids[type][_index(cell)]

func evaporate(delta: float) -> void:
	var factor := maxf(0.0, 1.0 - Constants.PHEROMONE_EVAPORATION_RATE * delta)
	for t in Type.size():
		for i in _grids[t].size():
			_grids[t][i] = _grids[t][i] * factor

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(world_pos.x / Constants.GRID_CELL_SIZE),
		floori(world_pos.y / Constants.GRID_CELL_SIZE)
	)

func _in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < _width and cell.y >= 0 and cell.y < _height

func _index(cell: Vector2i) -> int:
	return cell.y * _width + cell.x

func _draw() -> void:
	for y in _height:
		for x in _width:
			var cell   := Vector2i(x, y)
			var search := read_vector(Type.SEARCH, cell).length()
			var ret    := read_vector(Type.RETURN,  cell).length()
			if search < 0.01 and ret < 0.01:
				continue
			draw_rect(
				Rect2(x * Constants.GRID_CELL_SIZE, y * Constants.GRID_CELL_SIZE,
					  Constants.GRID_CELL_SIZE, Constants.GRID_CELL_SIZE),
				Color(ret, search, 0.0, 0.6)
			)
