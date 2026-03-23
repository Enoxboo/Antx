class_name Main
extends Node2D

const FoodScene := preload("uid://3qxu4qxc7b0o")

@onready var _pheromone_grid: PheromoneGrid = $PheromoneGrid
@onready var _anthill:        Anthill       = $Anthill

var _food_sources: Array[FoodSource] = []

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

	_anthill.setup(_pheromone_grid, _food_sources)
	_anthill.defeated.connect(_on_defeat)
	_anthill.set_spawning(true)

func _on_defeat() -> void:
	get_tree().paused = true
