extends Node2D

var boidScene = preload("res://Scenes/Boid.tscn")
var boids = []

var visual_range = 80
var max_speed = 10
var min_speed = 5
var margin = 50 
var turn_factor = 1

var separation_factor = 0.1
var alignment_factor = 0.1
var cohesion_factor = 0.05

var running = false

func add_boids(n):
	for _i in range(0, n):
		var instance = boidScene.instance()
		boids.append(instance)
		add_child(instance)

func _process(_delta):
	if !running:
		return

	for i in range(0, boids.size()):
		boids[i].update_steering(boids, visual_range, separation_factor, alignment_factor, cohesion_factor)
		boids[i].keep_within(margin, turn_factor)
		boids[i].limit_speed(min_speed, max_speed)

	for i in range(0, boids.size()):
		boids[i].move()

func _input(_ev):
	if Input.is_key_pressed(KEY_S):
		running = !running
	if Input.is_key_pressed(KEY_A):
		add_boids(300)
