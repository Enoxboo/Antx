class_name Main
extends Node2D

const AntScene  := preload("uid://cio54ppmsbowc")
const FoodScene := preload("uid://3qxu4qxc7b0o")

@onready var _pheromone_grid: PheromoneGrid = $PheromoneGrid

var _food_sources: Array[FoodSource] = []
var _home_cell: Vector2i

func _ready() -> void:
	_home_cell = _pheromone_grid.world_to_cell(Vector2(960, 540))

	var food: FoodSource = FoodScene.instantiate()
	food.global_position = Vector2(1200, 400)
	add_child(food)
	food.setup(_pheromone_grid)
	_food_sources.append(food)

	for i in 10:
		var ant: AntBase = AntScene.instantiate()
		ant.global_position = Vector2(960, 540) + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		add_child(ant)
		ant.setup(_pheromone_grid, _food_sources, _home_cell)
