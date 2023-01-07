extends Node2D

export var VISUAL_RANGE = 60
export var ROWS = 9 * 2
export var COLS = 16 * 2
export var MARGIN = 50
export var TURN_FACTOR = 3
#								green	purple	blue
export var SEPARATION_FACTOR = [0.2,	0.2,	0.2]
export var ALIGNMENT_FACTOR  = [0.1,	0.1,	0.1]
export var COHESION_FACTOR   = [0.05,	0.05,	0.05]
export var RANDOM_FACTOR     = [2,   	1,		0]
export var MAX_SPEED         = [10,		10,		10]
export var MIN_SPEED         = [5,		5,		5]

export var RUNNING = false
export var DRAW = false

var boid_scene = preload("res://Scenes/Boid.tscn")
export var BOIDS = []
var grid
var boids_num = 0

func _ready():
	$Label.text = "number of boids: %d" % boids_num
	grid = []
	for _x in range(ROWS):
		var b = []
		for _y in range(COLS):
			b.append([0]);
		grid.append(b)

func add_boids(n):
	randomize()
	for i in range(n):
		var instance = boid_scene.instance()
		add_child(instance)
		BOIDS.append(instance)
		BOIDS[boids_num].set_species(i % 3)
		var gp = BOIDS[boids_num].get_grid_pos()
		grid[gp.x][gp.y].append(boids_num)
		boids_num += 1
	
	$Label.text = "number of boids: %d" % boids_num

func _input(_ev):
	if Input.is_key_pressed(KEY_S): RUNNING = !RUNNING
	if Input.is_key_pressed(KEY_A): add_boids(100)
	if Input.is_key_pressed(KEY_Q): get_tree().quit()
	if Input.is_key_pressed(KEY_D):
		DRAW = !DRAW
		update()

func _draw():
	var ws = Vector2(COLS * VISUAL_RANGE, ROWS * VISUAL_RANGE);
	OS.set_min_window_size(ws)
	OS.set_max_window_size(ws)
	if !DRAW: return
	for i in range(VISUAL_RANGE, ROWS * VISUAL_RANGE, VISUAL_RANGE):
		draw_line(Vector2(0, i), Vector2(ws.x, i), Color(0, 255, 0))
	for i in range(VISUAL_RANGE, COLS * VISUAL_RANGE, VISUAL_RANGE):
		draw_line(Vector2(i, 0), Vector2(i, ws.y), Color(0, 255, 0))

func _process(_delta):
	if !RUNNING: return
	
	for x in range(ROWS):
		for y in range(COLS):
			grid[x][y][0] = grid[x][y].size()
			var cells = []
			for a in [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]:
				if x + a[0] >= 0 and y + a[1] >= 0 and x + a[0] < ROWS and y + a[1] < COLS: cells.append(grid[x + a[0]][y + a[1]])
			for i in range(1, grid[x][y][0]):
				BOIDS[grid[x][y][i]].steer(cells)
				BOIDS[grid[x][y][i]].limit_speed()
	
	for x in range(ROWS):
		for y in range(COLS):
			for i in range(grid[x][y][0] - 1, 0, -1):
				BOIDS[grid[x][y][i]].move()
				var gp = BOIDS[grid[x][y][i]].get_grid_pos()
				grid[gp.x][gp.y].append(grid[x][y][i])
				grid[x][y].remove(i)
