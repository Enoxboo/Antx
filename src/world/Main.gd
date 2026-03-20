class_name Main
extends Node2D

const AntScene  := preload("uid://cio54ppmsbowc")
const FoodScene := preload("uid://3qxu4qxc7b0o")

@onready var _pheromone_grid: PheromoneGrid = $PheromoneGrid

var _food_sources: Array[FoodSource] = []
var _home_pos:     Vector2           = Vector2(960, 540)

func _ready() -> void:
	var food_positions := [
		Vector2(1200, 400),
		Vector2(300,  200),
		Vector2(1600, 700),
		Vector2(500,  800),
		Vector2(1400, 150),
	]

	for pos in food_positions:
		var food: FoodSource = FoodScene.instantiate()
		food.global_position = pos
		add_child(food)
		food.setup(_pheromone_grid)
		_food_sources.append(food)

	for i in 100:
		var ant: AntBase = AntScene.instantiate()
		ant.global_position = _home_pos + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		add_child(ant)
		ant.setup(_pheromone_grid, _food_sources, _home_pos)
