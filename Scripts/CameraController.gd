extends Camera

var angle = 0
var mode = 3
var side = 1

onready var my_player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# steady rotation
	if mode == 0:
		angle += delta * 0.5
		translation.x = sin(angle) * 10
		translation.z = cos(angle) * 10
		rotation.y = angle
		if angle == 2 * PI:
			angle = 0
	
	# lerp rotate to side	
	elif mode == 2:
		angle = lerp(angle, side * PI, delta * 4)
		translation.x = sin(angle) * 10
		translation.z = cos(angle) * 10
		rotation.y = angle
		#if (abs(angle - (side * PI)) < 0.005):
		#	side += 0.5
	
	elif mode == 3:
		#look_at(my_player.translation, Vector3(0,1,0))
		translation.x = lerp(translation.x, my_player.translation.x / 1.5, delta * 4)
		translation.z = lerp(translation.z, (my_player.translation.z / 3) + 9, delta * 4)
		rotation.y = -translation.x / 50


func get_angle():
	return angle

func get_side():
	return side
