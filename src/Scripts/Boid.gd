extends Node2D

var d: Vector2
var nd: Vector2

var r: int
var c: int 

func _ready():
	randomize()
	d = Vector2(rand_range(0, 10) - 5, rand_range(0, 10) - 5)
	rotation = d.angle()

func update_steering(boidsa, visual_range, separation_factor, alignment_factor, cohesion_factor):
	nd = d
	var separation = Vector2(0, 0)
	var alignment = Vector2(0, 0)
	var cohesion = Vector2(0, 0)
	var n = 0
	for boids in boidsa:
		for i in range(0, boids.size()):
			var diff = position - boids[i].position
			var diff_length = diff.length()
			if diff_length != 0 and diff_length < visual_range:
				n += 1
				separation += diff / diff_length
				alignment += boids[i].d
				cohesion += boids[i].position		
	if n != 0:
		nd += separation * separation_factor
		nd += (alignment / n - d) * alignment_factor
		nd += (cohesion  / n - position) * cohesion_factor

func keep_within(margin, turn_factor):
	if position.x < margin:
		nd.x += turn_factor
	if position.x > OS.window_size.x - margin:
		nd.x -= turn_factor
	if position.y < margin:
		nd.y += turn_factor
	if position.y > OS.window_size.y - margin:
		nd.y -= turn_factor

func limit_speed(min_speed, max_speed):
	var speed = nd.length()
	if speed > max_speed:
		nd *= max_speed / speed
	if speed < min_speed:
		nd *= min_speed / speed

func move():
	d = nd
	rotation = d.angle()
	position += d
