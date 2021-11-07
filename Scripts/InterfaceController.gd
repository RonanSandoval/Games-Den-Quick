extends Node

var my_hearts = [] 
onready var my_points = get_node("Points")
onready var my_player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	my_hearts.push_back(get_node("Health1"))
	my_hearts.push_back(get_node("Health2"))
	my_hearts.push_back(get_node("Health3"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	my_points.bbcode_text = "[right]Points: " + str(my_player.points) + "[/right]"
	my_hearts[0].visible = my_player.health > 0
	my_hearts[1].visible = my_player.health > 1
	my_hearts[2].visible = my_player.health > 2
