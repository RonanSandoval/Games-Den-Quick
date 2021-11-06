extends Area


# Declare member variables here. Examples:
var direction = 1
var speed = 0
var degree = 0
var disappear = false

const ANGLE_SPEED = 5

onready var my_player = get_node("../../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	if "Bee" in name:
		speed = 2
		if translation.x < 0:
			direction = 1
		else:
			direction = -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	degree += delta * ANGLE_SPEED
	if disappear:
		scale.x -= delta * 3
		if scale.x < 0:
			queue_free()
	else:
		
		if "Bee" in name:
			bee_AI(delta)
		pass

func bee_AI(delta):
	translation.x += direction * delta * speed
	translation.y += sin(degree) * 0.01
	if abs(translation.x) > 15:
		disappear = true
