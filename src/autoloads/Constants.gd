class_name Constants

## Central repository for all tunable gameplay values.
## No magic numbers anywhere else in the codebase — everything lives here.

# -- World --
const WORLD_WIDTH  := 1920
const WORLD_HEIGHT := 1080

# -- PHEROMONES --
const PHEROMONE_EVAPORATION_RATE := 0.01
const PHEROMONE_DIFFUSION_RATE    := 0.05
const PHEROMONE_MAX_STRENGTH      := 100.0
const PHEROMONE_EMIT_INTERVAL     := 0.2

# -- GRID --
const GRID_CELL_SIZE := 16

# -- ANT --
const ANT_SPEED_WORKER  := 60.0
const ANT_SPEED_SOLDIER := 45.0
