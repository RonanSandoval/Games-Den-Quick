extends Area


# Declare member variables here. Examples:
var direction = 1
var speed = 0
var degree = 0
var disappear = false
var appear = false

var counter = 0
var mode = 0

const ANGLE_SPEED = 5

onready var my_player = get_node("../../Player")
onready var my_game = get_node("../../GameController")
onready var my_floor = get_node("../../Floor")
onready var my_collision = get_child(0)
onready var my_sprite = get_child(1)
onready var my_shadow = get_child(2)

# Called when the node enters the scene tree for the first time.
func _ready():
	my_collision.disabled = true
	if "Bee" in name:
		my_sprite.translation.y = 20
		my_shadow.scale = Vector3(0.1, 0.1,1)
		speed = 3
		if translation.x < 0:
			direction = 1
		else:
			direction = -1
	elif "Spiny" in name:
		scale.x = 0
		appear = true
		counter = 3
	else: 
		scale.x = 0
		appear = true
		counter = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disappear:
		scale.x -= delta * 3
		if scale.x < 0:
			queue_free()
	
	elif appear:
		scale.x += delta * 3
		if not scale.x < 1:
			appear = false 
	else:
		
		if "Bee" in name:
			bee_AI(delta)
		if "Spiny" in name:
			spiny_AI(delta)
		if "Spider" in name:
			spider_AI(delta)
		pass
	
	if my_game.game_state == 3:
		disappear = true

func bee_AI(delta):
	degree += delta * ANGLE_SPEED
	if mode == 1:
		my_collision.disabled = false
		my_sprite.translation.y += sin(degree) * 0.01
	if mode == 0:
		my_sprite.translation.y = lerp(my_sprite.translation.y, 0.5, 0.04)
		if abs(my_sprite.translation.y - 0.5) < 0.1:
			mode = 1
	if mode == 2:
		my_sprite.translation.y = lerp(20, my_sprite.translation.y, 0.99)
		if abs(my_sprite.translation.y - 20) < 0.1:
			disappear = true
			
	my_shadow.scale = Vector3((1/my_sprite.translation.y)/1.5,(1/my_sprite.translation.y)/1.5,0)
	translation.x += direction * delta * speed
	if abs(translation.x) > 15:
		mode = 2
	
	if direction < 0:
		my_sprite.set_flip_h(false)
	else:
		my_sprite.set_flip_h(true)

func spiny_AI(delta):
	if mode == 0:
		counter -= delta
		if counter < 0:
			degree += delta * ANGLE_SPEED
			my_sprite.rotation.y = degree
			if(degree > 3*PI/2):
				my_sprite.set_animation("adult")
			if (degree > 2*PI):
				mode = 1
				counter = 10
	if mode == 1:
		my_sprite.set_animation("adult")
		my_collision.disabled = false
		degree += delta * ANGLE_SPEED
		my_sprite.rotation.y += cos(degree) * 0.03
		counter -= delta
		if counter < 0:
			disappear = true
		
	pass

func spider_AI(delta):
	if mode == 0:
		counter -= delta
		if counter < 0:
			degree += delta * ANGLE_SPEED
			my_sprite.rotation.y = degree
			if(degree > 3*PI/2):
				my_sprite.set_animation("adult")
			if (degree > 2*PI):
				mode = 1
				counter = 8
				degree = [PI/4, 3*PI/4, 5*PI/4, 7*PI/4][randi()%4]
	if mode == 1:
		my_sprite.set_animation("adult")
		my_collision.disabled = false
		
		translation.x += cos(degree) * 4 * delta
		translation.z += sin(degree) * 4 * delta
		
		# wall bounce
		if (translation.x > my_floor.scale.x - 0.5 or translation.x < -my_floor.scale.x + 0.5):
			degree = PI - degree
			if (degree < 0):
				degree += 2 * PI
			if (degree > 2 * PI):
				degree -= 2 * PI
			#translation.x += cos(angle) * vel * delta * 2
			translation.x = sign(translation.x) * (my_floor.scale.x - 0.6)
		
		if (translation.z > my_floor.scale.z - 0.5 or translation.z < -my_floor.scale.z + 0.5):
			degree = -degree
			if (degree < 0):
				degree += 2 * PI
			if (degree > 2 * PI):
				degree -= 2 * PI
			translation.z = sign(translation.z) * (my_floor.scale.z - 0.6)
		
		if not disappear:
			if cos(degree) > 0:
				my_sprite.rotation.y = lerp(my_sprite.rotation.y, 0, 0.2)
				#my_sprite.set_flip_h(false)
			else:
				#my_sprite.set_flip_h(true)
				my_sprite.rotation.y = lerp(my_sprite.rotation.y, -PI, 0.2)
		
		counter -= delta
		if counter < 0:
			disappear = true
		
	pass

