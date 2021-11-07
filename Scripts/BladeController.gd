extends Sprite3D

var disappear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not disappear:
		if scale.x < 1:
			scale.x += delta * 3
	else:
		scale.x -= delta * 3
		if scale.x < 0:
			queue_free()
