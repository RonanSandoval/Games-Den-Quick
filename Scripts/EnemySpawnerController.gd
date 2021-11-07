extends Node

var counter_enemy = 0
var counter_food = 0
var counter_round = 0
var counter_rest = 0
var curr_round = 0
var end_timer = 2.5

const BEE = preload("res://Scenes/Bee.tscn")
const FOOD = preload("res://Scenes/Food.tscn")
const SPINY = preload("res://Scenes/Spiny.tscn")
const SPIDER = preload("res://Scenes/Spider.tscn")

onready var my_game = get_node("../GameController")

const GAME_SPEED = 1
const ROUND_SPEED = [0, 3, 2, 1.75, 3.5, 2.5, -1]
const ROUND_TYPE = [[0], [1], [2,2,2,1], [1,1,2], [3], [2,2,3], [1,1,1,1,2,2,2,3]]
const ROUND_LENGTH = [10, 25, 15, 20, 15, 20, -1]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	counter_enemy = 1
	counter_food = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_game.game_state != 2:
		curr_round = 6
		counter_round = ROUND_LENGTH[0]
		counter_enemy = ROUND_SPEED[0]
		counter_food = 2.5
		end_timer = 2.5
		return
	
	if counter_rest > 0:
		counter_rest -= delta * GAME_SPEED
	else:
		counter_enemy -= delta * GAME_SPEED
		counter_food -= delta * GAME_SPEED
		counter_round -= delta * GAME_SPEED
	
	if counter_enemy < 0 and curr_round > 0 and not counter_rest > 0:
		var choice = ROUND_TYPE[curr_round][randi() % ROUND_TYPE[curr_round].size()]
		if choice == 1:
			spawn_bee()
		elif choice == 2:
			spawn_spiny()
		elif choice == 3:
			spawn_spider()
		
		if curr_round != 6:
			counter_enemy = ROUND_SPEED[curr_round]
		else:
			counter_enemy = end_timer
			if end_timer > 0.4:
				end_timer -= 0.02
				print(end_timer)
	
	if counter_food < 0:
		spawn_food()
		counter_food = 2.5
	
	if counter_round < 0 and curr_round != 6:
		curr_round += 1
		counter_round = ROUND_LENGTH[curr_round]
		if curr_round in [1,2,4,6]:
			counter_rest = 4
		
		

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
	
func spawn_spider():
	var spider_instance = SPIDER.instance()
	spider_instance.translation = Vector3(rand_range(-10,10),1.5,rand_range(-5,5))
	add_child(spider_instance)


func spawn_food():
	var food_instance = FOOD.instance()
	food_instance.translation = Vector3(rand_range(-10,10),0.5,rand_range(-5,5))
	add_child(food_instance)
	
