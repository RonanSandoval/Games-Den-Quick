extends Node

var counter_enemy = 0
var counter_food = 0
var level = 1

const BEE = preload("res://Scenes/Bee.tscn")
const FOOD = preload("res://Scenes/Food.tscn")
const SPINY = preload("res://Scenes/Spiny.tscn")

onready var my_game = get_node("../GameController")

const GAME_SPEED = 2
const SPAWN_SPEED = [1]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	counter_enemy = 1
	counter_food = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_game.game_state != 2:
		return
	
	counter_enemy -= delta * GAME_SPEED
	counter_food -= delta * GAME_SPEED
	if counter_enemy < 0:
		if randf() < 0.5:
			spawn_spiny()
			pass
		else:
			spawn_bee()
		counter_enemy = 3
	
	if counter_food < 0:
		spawn_food()
		counter_food = 5
	
	

func spawn_bee():
	var bee_instance = BEE.instance()
	if randf() < 0.5:
		bee_instance.translation = Vector3(15,0.5,rand_range(-5,5))
	else:
		bee_instance.translation = Vector3(-15,0.5,rand_range(-5,5))
	add_child(bee_instance)

func spawn_spiny():
	var spiny_instance = SPINY.instance()
	spiny_instance.translation = Vector3(rand_range(-10,10),1.5,rand_range(-5,5))
	add_child(spiny_instance)


func spawn_food():
	var food_instance = FOOD.instance()
	food_instance.translation = Vector3(rand_range(-10,10),0.5,rand_range(-5,5))
	add_child(food_instance)
	
