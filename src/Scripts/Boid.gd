extends Node2D

var d: Vector2
var nd: Vector2

func _ready():
	randomize()
	position = Vector2(rand_range(0, OS.window_size.x), rand_range(0, OS.window_size.y))
	d = Vector2(rand_range(0, 10) - 5, rand_range(0, 10) - 5)
	rotation = d.angle()
	
func get_grid_pos():
	var row = floor(position.y / $"../Global".VISUAL_RANGE) 
	if row < 0: row = 0
	if row >= $"../Global".ROWS: row = $"../Global".ROWS - 1
	var col = floor(position.x / $"../Global".VISUAL_RANGE)
	if col < 0: col = 0
	if col >= $"../Global".COLS: col = $"../Global".COLS - 1
	return Vector2(row, col)

func steer(cells):
	nd = d
	var separation = Vector2(0, 0)
	var alignment = Vector2(0, 0)
	var cohesion = Vector2(0, 0)
	var n = 0
	for cell in cells:
		for i in range(0, cell.size()):
			var diff = position - cell[i].position
			var diff_length = diff.length()
			if diff_length != 0 and diff_length < $"../Global".VISUAL_RANGE:
				n += 1
				separation += diff / diff_length
				alignment += cell[i].d
				cohesion += cell[i].position		
	if n != 0:
		nd += separation * $"../Global".SEPARATION_FACTOR
		nd += (alignment / n - d) * $"../Global".ALIGNMENT_FACTOR
		nd += (cohesion  / n - position) * $"../Global".COHESION_FACTOR

func keep_within():
	if position.x < $"../Global".MARGIN:
		nd.x += $"../Global".TURN_FACTOR
	if position.x > OS.window_size.x - $"../Global".MARGIN:
		nd.x -= $"../Global".TURN_FACTOR
	if position.y < $"../Global".MARGIN:
		nd.y += $"../Global".TURN_FACTOR
	if position.y > OS.window_size.y - $"../Global".MARGIN:
		nd.y -= $"../Global".TURN_FACTOR

func limit_speed():
	var speed = nd.length()
	if speed > $"../Global".MAX_SPEED:
		nd *= $"../Global".MAX_SPEED / speed
	if speed < $"../Global".MIN_SPEED:
		nd *= $"../Global".MIN_SPEED / speed

func move():
	d = nd
	rotation = d.angle()
	position += d
