extends Node2D

var boidScene = preload("res://Scenes/Boid.tscn")
var boids = []
var boidsnum = 0 

var visual_range = 75
var max_speed = 10
var min_speed = 5
var margin = 50 
var turn_factor = 1

var separation_factor = 0.2
var alignment_factor = 0.1
var cohesion_factor = 0.05

var running = false

var rows = 9 * 2
var cols = 16 * 2

func _ready():
	OS.set_min_window_size(Vector2(cols*visual_range,rows*visual_range))
	OS.set_max_window_size(Vector2(cols*visual_range,rows*visual_range))
	#OS.center_window()
	for x in range(rows):
		var a = []
		for y in range(cols):
			a.append([]);
		boids.append(a)

func add_boids(n):
	randomize()
	for _i in range(n):
		var instance = boidScene.instance()
		var p = Vector2(rand_range(0, OS.window_size.x), rand_range(0, OS.window_size.y))
		var row = floor(p.y / (visual_range)) 
		var col = floor(p.x / (visual_range)) 
		instance.position = p
		instance.r = row
		instance.c = col
		boids[row][col].append(instance)
		add_child(instance)
	boidsnum += n
	$Label.text = "number of boids: %d" % boidsnum 

func _process(_delta):
	if !running:
		return

	for x in range(rows):
		for y in range(cols):
			var boidsa = []
			for a in [
				[-1, -1],
				[-1, 0],
				[-1, 1],
				[0, -1],
				[0, 0],
				[0, 1],
				[1, -1],
				[1, 0],
				[1, 1]
				]:
				if x + a[0] < 0 or y + a[1] < 0 or x + a[0] >= rows or y + a[1] >= cols:
					continue
				boidsa.append(boids[x+a[0]][y+a[1]])
			
			for i in range(0, boids[x][y].size()):
				boids[x][y][i].update_steering(boidsa, visual_range, separation_factor, alignment_factor, cohesion_factor)
				boids[x][y][i].keep_within(margin, turn_factor)
				boids[x][y][i].limit_speed(min_speed, max_speed)
	var nboids = []
	for x in range(rows):
		var a = []
		for y in range(cols):
			a.append([]);
		nboids.append(a)
		
	for x in range(rows):
		for y in range(cols):
			for i in range(0, boids[x][y].size()):
				boids[x][y][i].move()
				var row = floor(boids[x][y][i].position.y / (visual_range)) 
				if row >= rows: 
					row = rows - 1
				var col = floor(boids[x][y][i].position.x / (visual_range))
				if col >= cols: 
					col = cols - 1
				boids[x][y][i].r = row
				boids[x][y][i].c = col
				nboids[row][col].append(boids[x][y][i])
	boids = nboids

func _input(_ev):
	if Input.is_key_pressed(KEY_S):
		running = !running
	if Input.is_key_pressed(KEY_A):
		add_boids(200)

func _draw():
	for i in range(0, rows+1):
		draw_line(Vector2(0, i *  visual_range), Vector2(OS.window_size.x, i *  visual_range), Color(0, 255, 0), 1)
	for i in range(0, cols+1):
		draw_line(Vector2(i * visual_range, 0), Vector2(i *  visual_range, OS.window_size.y), Color(0, 255, 0), 1)
