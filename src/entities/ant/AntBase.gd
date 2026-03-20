class_name AntBase
extends Node2D

enum State { EXPLORING, RETURNING }

const STRONG_PHEROMONE_FRAMES := 100
const MEMORY_SIZE             := 10

var _state:         State = State.EXPLORING
var _grid:          PheromoneGrid
var _food_sources:  Array[FoodSource]
var _home_pos:      Vector2
var _direction:     Vector2
var _emit_timer:    float = 0.0
var _strong_frames: int   = 0
var _visited_cells: Array[Vector2i] = []
var _transition_cooldown: float = 0.0

func setup(grid: PheromoneGrid, food_sources: Array[FoodSource], home_pos: Vector2) -> void:
	_grid         = grid
	_food_sources = food_sources
	_home_pos     = home_pos
	_direction    = Vector2.RIGHT.rotated(randf() * TAU)

func _process(delta: float) -> void:
	_steer()
	global_position += _direction * Constants.ANT_SPEED_WORKER * delta
	_clamp_to_world()
	_update_memory()

	_emit_timer += delta
	if _emit_timer >= Constants.PHEROMONE_EMIT_INTERVAL:
		_emit_pheromone()
		_emit_timer = 0.0

	if _strong_frames > 0:
		_strong_frames -= 1

	if _transition_cooldown > 0.0:
		_transition_cooldown -= delta
	else:
		_check_state_transition()

func _steer() -> void:
	var food_dir := _detect_food_direction()
	if food_dir != Vector2.ZERO:
		_direction = _direction.lerp(food_dir, 0.8).normalized()
	else:
		var dominant_dir := _read_sensors()
		if dominant_dir != Vector2.ZERO:
			_direction = _direction.lerp(dominant_dir, Constants.ANT_STEER_STRENGTH).normalized()
	_direction = _direction.rotated(randf_range(-Constants.ANT_RANDOM_ANGLE, Constants.ANT_RANDOM_ANGLE))
	_direction = _direction.normalized()

func _read_sensors() -> Vector2:
	var pheromone_type := PheromoneGrid.Type.RETURN if _state == State.EXPLORING else PheromoneGrid.Type.SEARCH
	var dist           := Constants.SENSOR_DISTANCE * Constants.GRID_CELL_SIZE

	var sensor_dirs := [
		_direction.rotated(-deg_to_rad(45.0)),
		_direction,
		_direction.rotated( deg_to_rad(45.0)),
	]

	var best_dir      := Vector2.ZERO
	var best_strength := 0.0

	for dir in sensor_dirs:
		var cell: Vector2i = _grid.world_to_cell(global_position + dir * dist)
		if _visited_cells.has(cell):
			continue
		var vec      := _grid.read_vector(pheromone_type, cell)
		var strength := vec.length()
		if strength > best_strength:
			best_strength = strength
			best_dir      = -vec.normalized()

	return best_dir

func _detect_food_direction() -> Vector2:
	if _state != State.EXPLORING:
		return Vector2.ZERO
	var radius := Constants.FOOD_DETECT_RADIUS * Constants.GRID_CELL_SIZE
	for source in _food_sources:
		var to_food := source.global_position - global_position
		if to_food.length() > radius:
			continue
		if abs(_direction.angle_to(to_food.normalized())) <= deg_to_rad(60.0):
			return to_food.normalized()
	return Vector2.ZERO

func _emit_pheromone() -> void:
	var cell   := _grid.world_to_cell(global_position)
	var weight := Constants.PHEROMONE_DEPOSIT_STRONG if _strong_frames > 0 else Constants.PHEROMONE_DEPOSIT_WEIGHT
	var type   := PheromoneGrid.Type.SEARCH if _state == State.EXPLORING else PheromoneGrid.Type.RETURN
	_grid.deposit(type, cell, _direction * weight)

func _check_state_transition() -> void:
	match _state:
		State.EXPLORING:
			for source in _food_sources:
				if global_position.distance_to(source.global_position) < Constants.GRID_CELL_SIZE:
					_state                = State.RETURNING
					_direction            = -_direction
					_strong_frames        = STRONG_PHEROMONE_FRAMES
					_transition_cooldown  = 1.0
					_visited_cells.clear()
					return
		State.RETURNING:
			if global_position.distance_to(_home_pos) < Constants.GRID_CELL_SIZE * 2.0:
				_state                = State.EXPLORING
				_direction            = -_direction
				_strong_frames        = STRONG_PHEROMONE_FRAMES
				_transition_cooldown  = 1.0
				_visited_cells.clear()

func _update_memory() -> void:
	var current_cell := _grid.world_to_cell(global_position)
	if _visited_cells.is_empty() or _visited_cells.back() != current_cell:
		_visited_cells.append(current_cell)
		if _visited_cells.size() > MEMORY_SIZE:
			_visited_cells.pop_front()

func _clamp_to_world() -> void:
	var clamped := global_position
	clamped.x   = clampf(clamped.x, 0.0, Constants.WORLD_WIDTH)
	clamped.y   = clampf(clamped.y, 0.0, Constants.WORLD_HEIGHT)
	if clamped != global_position:
		global_position = clamped
		_direction      = -_direction

func is_walkable(cell: Vector2i) -> bool:
	# Stub — always true until WorldGrid is implemented in Jalon 2
	return _grid._in_bounds(cell)
