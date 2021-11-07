extends Node

onready var my_floor = get_node("../Floor")

const BLADE = preload("res://Scenes/Blade.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.
	

func generate(count):
	for i in count:
		var grass_instance = BLADE.instance()
		grass_instance.translation = Vector3(rand_range(-13,13),1,rand_range(-4,4))
		grass_instance.set_frame(randi() % 4)
		grass_instance.set_flip_h(randf() < 0.5)
		add_child(grass_instance)

func reset():
	for child in get_children():
		child.disappear = true
