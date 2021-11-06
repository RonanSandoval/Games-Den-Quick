extends Node

var counter = 0
var level = 1

const BEE = preload("res://Scenes/Bee.tscn")

const GAME_SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	counter = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter -= delta * GAME_SPEED
	if counter < 0:
		spawn_bee()
		counter = 1
		

func spawn_bee():
	var bee_instance = BEE.instance()
	if randf() < 0.5:
		bee_instance.translation = Vector3(15,0.5,rand_range(-5,5))
	else:
		bee_instance.translation = Vector3(-15,0.5,rand_range(-5,5))
	add_child(bee_instance)
	
