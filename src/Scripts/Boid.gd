extends Node2D

#variables

#position
var direction: Vector2
var new_direction: Vector2

var RADIUS: int = 100
var separation: bool = true
var alignment: bool = true
var cohesion: bool = true

func _ready():
	position = Vector2(rand_range(0,400), rand_range(0,400))
	direction = Vector2(rand_range(-1,1), rand_range(-1,1))
	direction /= direction.length()
	pass


func update_direction(flock):
	var avg_position: Vector2
	var avg_direction: Vector2
	var separation_vec: Vector2
	for boid in flock: 
		var distance = (boid.position - position).length()
		if boid.position != position and distance <= RADIUS:
			if cohesion:
				avg_position += boid.position * distance
			if alignment:
				avg_direction += boid.direction * distance
			if separation:
				separation_vec += (position - boid.position) / distance	
			new_direction = separation_vec + avg_position + avg_direction
			new_direction /= new_direction.length()
	pass

func move():
	direction = new_direction
	position += direction	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position += direction
	pass
