extends Node

onready var parent = get_parent()
onready var my_nature = get_node("../NatureSpawner")

# Declare member variables here. Examples:
var game_state = 0

var counter = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	my_nature.generate(10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_state == 3:
		counter -= delta
		if counter < 0:
			print("ready for next game")
			game_state = 0
			my_nature.reset()
			my_nature.generate(10)

func _input(event):
	if event is InputEventKey and game_state == 0:
		if event.pressed:
			print("start game")
			game_state = 1
			counter = 3
