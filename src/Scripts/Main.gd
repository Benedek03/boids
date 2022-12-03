extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

var boid = preload("res://Scenes/Boid.tscn")
var flock = []

func _ready():
	for i in range(0, 20):
		flock.append(boid.instance())
		add_child(flock[i])
	pass


func _process(delta):
	for boid in flock:
		boid.update_direction(flock)
		boid.move()
	pass
