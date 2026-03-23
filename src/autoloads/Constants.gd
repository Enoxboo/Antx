class_name Constants

## Central repository for all tunable gameplay values.
## No magic numbers anywhere else in the codebase — everything lives here.

# -- WORLD --
const WORLD_WIDTH  := 1920
const WORLD_HEIGHT := 1080

# -- GRID --
const GRID_CELL_SIZE := 16

# -- PHEROMONES --
const PHEROMONE_EVAPORATION_RATE := 0.05
const PHEROMONE_EMIT_INTERVAL    := 0.1
const PHEROMONE_DEPOSIT_WEIGHT   := 0.015
const PHEROMONE_DEPOSIT_STRONG   := 0.04

# -- ANT --
const ANT_SPEED_WORKER    := 60.0
const ANT_SPEED_SOLDIER   := 45.0
const ANT_RANDOM_ANGLE    := 0.15
const ANT_STEER_STRENGTH  := 0.6
const SENSOR_DISTANCE     := 3
const FOOD_DETECT_RADIUS  := 8

# -- FOOD --
const FOOD_INITIAL_QUANTITY := 100.0

# -- ANTHILL --
const ANTHILL_HP_MAX          := 100.0
const ANTHILL_SPAWN_INTERVAL  := 3.0
const ANTHILL_SPAWN_FOOD_COST := 5.0
const ANTHILL_SPAWN_RADIUS    := 30.0
