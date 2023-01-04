extends Node2D

var boidScene = preload("res://Scenes/Boid.tscn")
var grid
var boidsnum = 0 

func create_map():
	var a = []
	for _x in range($Global.ROWS):
		var b = []
		for _y in range($Global.COLS):
			b.append([]);
		a.append(b)
	return a

func add_boids(n):
	randomize()
	for i in range(n):
		var instance = boidScene.instance()
		add_child(instance)
		instance.set_species(i % 3)
		var gp = instance.get_grid_pos()
		grid[gp.x][gp.y].append(instance)
	boidsnum += n
	$Label.text = "number of boids: %d" % boidsnum 

func _ready():
	$Label.text = "number of boids: %d" % boidsnum 
	grid = create_map()

func _process(_delta):
	if !$Global.RUNNING: return
	
	for x in range($Global.ROWS):
		for y in range($Global.COLS):
			var cells = []
			for a in [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]:
				if x + a[0] >= 0 and y + a[1] >= 0 and x + a[0] < $Global.ROWS and y + a[1] < $Global.COLS: cells.append(grid[x + a[0]][y + a[1]])
			for i in range(0, grid[x][y].size()):
				grid[x][y][i].steer(cells)
				grid[x][y][i].keep_within()
				grid[x][y][i].limit_speed()
	
	var ngrid = create_map()
	for x in range($Global.ROWS):
		for y in range($Global.COLS):
			for i in range(0, grid[x][y].size()):
				grid[x][y][i].move()
				var gp = grid[x][y][i].get_grid_pos()
				ngrid[gp.x][gp.y].append(grid[x][y][i])
	grid = ngrid

func _input(_ev):
	if Input.is_key_pressed(KEY_S): $Global.RUNNING = !$Global.RUNNING
	if Input.is_key_pressed(KEY_A): add_boids(100)
	if Input.is_key_pressed(KEY_Q): get_tree().quit()
	if Input.is_key_pressed(KEY_D):
		$Global.DRAW = !$Global.DRAW
		update()

func _draw():
	var ws = Vector2($Global.COLS * $Global.VISUAL_RANGE, $Global.ROWS * $Global.VISUAL_RANGE);
	OS.set_min_window_size(ws)
	OS.set_max_window_size(ws)
	if !$Global.DRAW: return
	for i in range($Global.VISUAL_RANGE, $Global.ROWS * $Global.VISUAL_RANGE, $Global.VISUAL_RANGE):
		draw_line(Vector2(0, i), Vector2(ws.x, i), Color(0, 255, 0))
	for i in range($Global.VISUAL_RANGE, $Global.COLS * $Global.VISUAL_RANGE, $Global.VISUAL_RANGE): 
		draw_line(Vector2(i, 0), Vector2(i, ws.y), Color(0, 255, 0))
