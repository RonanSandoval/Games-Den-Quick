extends Sprite3D

var spin = false

onready var my_ec = get_node("../EnemySpawner")
onready var my_game = get_node("../GameController")

const B1 = preload("res://Sprites/board-1.png")
const B2 = preload("res://Sprites/board-2.png")
const B3 = preload("res://Sprites/board-3.png")
const B4 = preload("res://Sprites/board-4.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	spin = true
	visible = false
	scale.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_game.game_state == 3:
		if scale.x > 0:
			scale.x -= delta * 6
		else:
			visible = false
		return
	if my_game.game_state == 1:
		visible = true
		if scale.x < 1:
			set_texture(B1)
			scale.x += delta * 6
		return
	
	if spin:
		if my_ec.curr_round == 6:
			scale.x -= delta * 6
			if scale.x < 0:
				spin = false
				visible = false
			return
		if my_ec.curr_round == 1:
			set_texture(B2)
		if my_ec.curr_round == 2:
			set_texture(B3)
		elif my_ec.curr_round == 4:
			set_texture(B4)
		rotation.y = lerp(rotation.y, 2*PI, 5 * delta)
		if abs(rotation.y - 2*PI) < 0.01:
			spin = false
			rotation.y = 0
