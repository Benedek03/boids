extends Node2D

var boidScene = preload("res://Scenes/Boid.tscn")
var boids = []

var boidsNum = 300
var visual_range = 80
var max_speed = 10
var min_speed = 5
var margin = 50 
var turn_factor = 1

var separation_factor = 0.1
var alignment_factor = 0.1
var cohesion_factor = 0.05

var running = false

func init_boids():
	randomize()
	for i in range(0, boidsNum):
		var instance = boidScene.instance()
		instance.position = Vector2(rand_range(0, OS.window_size.x), rand_range(0, OS.window_size.y))
		instance.d = Vector2(rand_range(0, 10) - 5, rand_range(0, 10) - 5)
		instance.rotation = instance.d.angle()
		boids.append(instance)
		add_child(instance)

func _process(delta):
	if !running:
		return
	
	for i in range(0, boids.size()):
		var boid = boids[i]
		boid.nd = boid.d
		var cohesion: Vector2
		var separation: Vector2
		var alignment: Vector2
		
		var neighbors = 0
		for j in range(0, boids.size()):
			if i != j and (boid.position - boids[j].position).length() < visual_range:
				neighbors += 1
				cohesion += boids[j].position
				var a = boid.position - boids[j].position
				var asd = 2
				if a.x != 0:
					if a.x > 0:
						separation.x += max(1 / a.x, asd)
					else:
						separation.x += min(1 / a.x, -asd)
				if a.y != 0:
					if a.y > 0:
						separation.y += max(1 / a.y, asd)
					else:
						separation.y += min(1 / a.y, -asd)
				alignment += boids[j].d
		
		if neighbors != 0:
			boid.nd += separation * separation_factor
			boid.nd += (alignment / neighbors - boid.d) * alignment_factor
			boid.nd += (cohesion  / neighbors - boid.position) * cohesion_factor
		
		if boid.position.x < margin:
			boid.nd.x += turn_factor
		if boid.position.x > OS.window_size.x - margin:
			boid.nd.x -= turn_factor
		if boid.position.y < margin:
			boid.nd.y += turn_factor
		if boid.position.y > OS.window_size.y - margin:
			boid.nd.y -= turn_factor
		
		var speed = boid.nd.length()
		if speed > max_speed:
			boid.nd *= max_speed / speed 
		if speed < min_speed:
			boid.nd *= min_speed / speed 			
		
	for i in range(0, boids.size()):
		boids[i].d = boids[i].nd
		boids[i].rotation = boids[i].d.angle()
		boids[i].position += boids[i].d

func _input(ev):
	if Input.is_key_pressed(KEY_S):
		if boids.size() == 0:
			init_boids()
		else:
			running = !running
