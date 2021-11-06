extends Node

onready var my_floor = get_node("../Floor")

const BLADE = preload("res://Scenes/Blade.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var grass_instance = BLADE.instance()
	grass_instance.translation = Vector3(rand_range(-my_floor.scale.x,my_floor.scale.x),0.5,rand_range(-my_floor.scale.z,my_floor.scale.z))
	add_child(grass_instance)
