extends Node2D

var d: Vector2
var nd: Vector2
var species

func _ready():
	randomize()
	position = Vector2(rand_range(0, OS.window_size.x), rand_range(0, OS.window_size.y))
	d = Vector2(rand_range(-5, 5), rand_range(-5, 5))
	rotation = d.angle()

func set_species(s):
	species = s
	if species == 0: $Sprite.self_modulate = Color("98971a")   #green
	elif species == 1: $Sprite.self_modulate = Color("b16286") #purple
	elif species == 2: $Sprite.self_modulate = Color("458588") #blue

func get_grid_pos():
	var row = floor(position.y / $"..".VISUAL_RANGE) 
	if row < 0: row = 0
	elif row >= $"..".ROWS: row = $"..".ROWS - 1
	var col = floor(position.x / $"..".VISUAL_RANGE)
	if col < 0: col = 0
	elif col >= $"..".COLS: col = $"..".COLS - 1
	return Vector2(row, col)

func steer(cells):
	nd = d
	var separation = Vector2(0, 0)
	var alignment = Vector2(0, 0)
	var cohesion = Vector2(0, 0)
	var n = 0
	var n2 = 0
	
	for cell in cells:
		for i in range(1, cell.size()):
			var diff = position - $"..".BOIDS[cell[i]].position
			var diff_length = diff.length()
			if diff_length != 0 and diff_length < $"..".VISUAL_RANGE:
				n += 1
				separation += diff / diff_length
				if species == $"..".BOIDS[cell[i]].species:
					n2 += 1
					alignment += $"..".BOIDS[cell[i]].d
					cohesion += $"..".BOIDS[cell[i]].position
	
	if n != 0:
		nd += separation * $"..".SEPARATION_FACTOR[species]
	if n2 != 0:
		nd += (alignment / n2 - d) * $"..".ALIGNMENT_FACTOR[species]
		nd += (cohesion  / n2 - position) * $"..".COHESION_FACTOR[species]
	nd += Vector2(rand_range(-1, 1), rand_range(-1, 1)) * $"..".RANDOM_FACTOR[species]
	
	if position.x < $"..".MARGIN: nd.x += $"..".TURN_FACTOR
	elif position.x > OS.window_size.x - $"..".MARGIN: nd.x -= $"..".TURN_FACTOR
	if position.y < $"..".MARGIN: nd.y += $"..".TURN_FACTOR
	elif position.y > OS.window_size.y - $"..".MARGIN: nd.y -= $"..".TURN_FACTOR

func limit_speed():
	var speed = nd.length()
	if speed > $"..".MAX_SPEED[species]: nd *= $"..".MAX_SPEED[species] / speed
	elif speed < $"..".MIN_SPEED[species]: nd *= $"..".MIN_SPEED[species] / speed

func move():
	d = nd
	rotation = d.angle()
	position += d
