extends Area

var angle = PI/4
var vel = 6
var counter = 1
# degree for starting spin
var degree = 0

var health = 3
var points = 0
var high_score = 0

var invincible = 0

const ANGLE_CHANGE = 2

const HIT_SOUND = preload("res://Sounds/hit.wav")
const GET_SOUND = preload("res://Sounds/popsicle_get.wav")

onready var my_cam = get_node("../Camera")
onready var my_floor = get_node("../Floor")
onready var my_game = get_node("../GameController")
onready var my_sprite = get_child(1)
onready var my_dust = get_child(2)
onready var my_shadow = get_child(3)
onready var my_explode = get_child(4)
onready var my_audio = get_child(5)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	connect("area_entered", self, "on_Player_area_entered")
	my_dust.emitting = false
	translation = Vector3(0,1.5,0)
	health = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_game.game_state == 0:
		health = 0
		counter = 1
		angle = PI/4
		degree = 0
		my_sprite.rotation.y = 0
		my_dust.emitting = false
		my_sprite.set_animation("child")
		if my_sprite.scale.x < 1.5:
			my_sprite.scale.x += delta * 5
		visible = true
		invincible = 0
		return
	
	if my_game.game_state == 1:
		my_sprite.scale.x = 1.5
		points = 0
		health = 3
		counter -= delta
		if counter < 0:
			degree += delta * 5
			my_sprite.rotation.y = degree
			if(degree > 3*PI/2):
				my_sprite.set_animation("adult")
			if (degree > 2*PI):
				my_sprite.rotation.y = 0
				my_game.game_state = 2
		return
	
	if my_game.game_state == 3:
		translation.x = lerp(translation.x, 0, 5 * delta)
		translation.z = lerp(translation.z, 0, 5 * delta)
		visible = false
		my_dust.emitting = false
		return
	
	my_dust.emitting = true
	
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
	
	if (translation.z > my_floor.scale.z - 1 or translation.z < -my_floor.scale.z + 1):
		angle = -angle
		if (angle < 0):
			angle += 2 * PI
		if (angle > 2 * PI):
			angle -= 2 * PI
		translation.z = sign(translation.z) * (my_floor.scale.z - 1.1)
	
	if invincible > 0:
		my_sprite.set_animation("ouch")
		invincible -= delta
		my_sprite.rotation.y += delta * invincible * 6
		if my_sprite.rotation.y > 2 * PI:
			my_sprite.rotation.y = 0
	else:
		my_sprite.set_animation("adult")
		invincible = 0
	
	if health == 0 and not invincible > 0:
		my_game.game_state = 3
		my_sprite.scale.x = 0
		if points > high_score:
			high_score = points
		
	


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
			my_explode.emitting = true
			health -= 1
			invincible = 3			
			my_audio.set_stream(HIT_SOUND)
			my_audio.play()
		area.disappear = true
	
	elif "Point" in groups:
		points += 1
		area.disappear = true
		area.my_particles.emitting = true
		
		my_audio.set_stream(GET_SOUND)
		my_audio.play()
