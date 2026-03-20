class_name FoodSource
extends Node2D

var _cell:    Vector2i
var quantity: float = Constants.FOOD_INITIAL_QUANTITY

func setup(grid: PheromoneGrid) -> void:
	_cell = grid.world_to_cell(global_position)

func get_cell() -> Vector2i:
	return _cell

func is_depleted() -> bool:
	return quantity <= 0.0
