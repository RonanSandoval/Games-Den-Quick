extends Area

var angle = PI/4
var vel = 6

var health = 3
var points = 0

var invincible = 0

const ANGLE_CHANGE = 2

onready var my_cam = get_node("../Camera")
onready var my_floor = get_node("../Floor")
onready var my_sprite = get_child(1)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "on_Player_area_entered")
	translation = Vector3(-2, 1.5, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation.x += cos(angle) * vel * delta
	translation.z += sin(angle) * vel * delta
	#rotation.y = my_cam.angle
	
	if not invincible > 0:
		if cos(angle) > 0:
			my_sprite.rotation.y = lerp(my_sprite.rotation.y, 0, 0.2)
			#my_sprite.set_flip_h(false)
		else:
			#my_sprite.set_flip_h(true)
			my_sprite.rotation.y = lerp(my_sprite.rotation.y, -PI, 0.2)
	
	getInput(delta)
	
	# wall bounce
	if (translation.x > my_floor.scale.x - 0.5 or translation.x < -my_floor.scale.x + 0.5):
		angle = PI - angle
		if (angle < 0):
			angle += 2 * PI
		if (angle > 2 * PI):
			angle -= 2 * PI
		#translation.x += cos(angle) * vel * delta * 2
		translation.x = sign(translation.x) * (my_floor.scale.x - 0.6)
	
	if (translation.z > my_floor.scale.z - 0.5 or translation.z < -my_floor.scale.z + 0.5):
		angle = -angle
		if (angle < 0):
			angle += 2 * PI
		if (angle > 2 * PI):
			angle -= 2 * PI
		translation.z = sign(translation.z) * (my_floor.scale.z - 0.6)
	
	if invincible > 0:
		invincible -= delta
		my_sprite.rotation.y += delta * invincible * 6
		if my_sprite.rotation.y > 2 * PI:
			my_sprite.rotation.y = 0
	else:
		invincible = 0
	


func getInput(delta):
	if (Input.is_action_just_pressed("move_left") and !(angle == 3*PI/4 or angle == 5*PI/4)):
		if (angle < PI):
			angle = 3*PI/4
		else:
			angle = 5*PI/4
	elif (Input.is_action_just_pressed("move_right") and !(angle == 1*PI/4 or angle == 7*PI/4)):
		if (angle < PI):
			angle = 1*PI/4
		else:
			angle = 7*PI/4
	elif (Input.is_action_just_pressed("move_down") and !(angle == 1*PI/4 or angle == 3*PI/4)):
		if (angle < PI/2 or angle > 3*PI/2):
			angle = 1*PI/4
		else:
			angle = 3*PI/4
	elif (Input.is_action_just_pressed("move_up") and !(angle == 5*PI/4 or angle == 7*PI/4)):
		if (angle < PI/2 or angle > 3*PI/2):
			angle = 7*PI/4
		else:
			angle = 5*PI/4
	
	
	if (angle < 0):
		angle += 2 * PI
	if (angle > 2 * PI):
		angle -= 2 * PI

func _on_Player_area_entered(area):
	var groups = area.get_groups() 
	if "Enemy" in groups:
		if not invincible > 0:
			health -= 1
			invincible = 3
		area.disappear = true
	elif "Point" in groups:
		points += 1
		area.disappear = true
		area.my_particles.emitting = true
