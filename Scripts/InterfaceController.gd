extends Node

var my_hearts = [] 
onready var my_game = get_node("../GameController")
onready var my_points = get_node("Points")
onready var my_player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	my_hearts.push_back(get_node("Health1"))
	my_hearts.push_back(get_node("Health2"))
	my_hearts.push_back(get_node("Health3"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_game.game_state != 0:
		my_points.bbcode_text = "[right]Score: " + str(my_player.points) + " [/right]"
	elif my_player.high_score > 0:
		my_points.bbcode_text = "[right]High Score: " + str(my_player.high_score) + " [/right]"
	else:
		my_points.bbcode_text = ""
	my_hearts[0].visible = my_player.health > 0
	my_hearts[1].visible = my_player.health > 1
	my_hearts[2].visible = my_player.health > 2
