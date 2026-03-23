class_name Anthill
extends Node2D

signal defeated
signal food_changed(new_total: float)

const ANT_SCENE := preload("uid://cio54ppmsbowc")

@export var spawn_timer: Timer

var hp:           float = Constants.ANTHILL_HP_MAX
var food_stored:  float = 5.0

var _grid:         PheromoneGrid
var _food_sources: Array[FoodSource]
var _spawning:     bool = true
var _spawn_queue:  float = 0.0   # fractional accumulator for spawn pacing

func setup(grid: PheromoneGrid, food_sources: Array[FoodSource]) -> void:
	_grid         = grid
	_food_sources = food_sources

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_tick)

# -- Food --

func deliver_food(amount: float) -> void:
	food_stored += amount
	food_changed.emit(food_stored)

func consume_food(amount: float) -> bool:
	if food_stored < amount:
		return false
	food_stored -= amount
	food_changed.emit(food_stored)
	return true

# -- Spawning --

func set_spawning(enabled: bool) -> void:
	_spawning = enabled
	if enabled:
		spawn_timer.start()
	else:
		spawn_timer.stop()

func _on_spawn_tick() -> void:
	if not _spawning:
		return
	if not consume_food(Constants.ANTHILL_SPAWN_FOOD_COST):
		return
	_spawn_ant()

func _spawn_ant() -> void:
	var ant: AntBase = ANT_SCENE.instantiate()
	ant.global_position = global_position + Vector2(
		randf_range(-Constants.ANTHILL_SPAWN_RADIUS, Constants.ANTHILL_SPAWN_RADIUS),
		randf_range(-Constants.ANTHILL_SPAWN_RADIUS, Constants.ANTHILL_SPAWN_RADIUS)
	)
	get_parent().add_child(ant)
	ant.setup(_grid, _food_sources, global_position)

# -- Combat --

func take_damage(amount: float) -> void:
	hp = maxf(0.0, hp - amount)
	if hp == 0.0:
		defeated.emit()
