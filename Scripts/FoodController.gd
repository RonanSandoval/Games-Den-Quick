extends Area

var mode = 0
var degree = 0
var disappear = false
var counter = 6
var dis_counter = 3

const ANGLE_SPEED = 5

onready var my_collision = get_child(0)
onready var my_sprite = get_child(1)
onready var my_shadow = get_child(2)
onready var my_particles = get_child(3)

# Called when the node enters the scene tree for the first time.
func _ready():
	my_sprite.translation.y = 20
	my_collision.disabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if disappear:
		dis_counter -= delta
		my_sprite.opacity = 0
		my_shadow.visible = false
		if dis_counter < 0:
			queue_free()
	
	degree += delta * ANGLE_SPEED
	if mode == 1:
		my_sprite.translation.y += sin(degree) * 0.01
		counter -= delta
		if counter < 0 :
			disappear = true
			
	if mode == 0:
		my_sprite.translation.y = lerp(my_sprite.translation.y, 0.5, 0.04)
		if abs(my_sprite.translation.y - 0.5) < 0.1:
			my_collision.disabled = false
			mode = 1
	my_sprite.rotation.z = sin(degree) / 4
	my_shadow.scale = Vector3((1/my_sprite.translation.y) / 1.5,(1/my_sprite.translation.y) / 1.5,0)

