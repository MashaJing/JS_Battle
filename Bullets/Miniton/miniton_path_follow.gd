extends PathFollow2D


export var flipped = false
export var speed = 200
onready var Miniton = $Miniton
onready var MinitonPlayer = $Miniton/AnimationPlayer
onready var MinitonSprite = $Miniton/AnimatedSprite


func _ready():
	MinitonSprite.flip_v = !flipped
	MinitonSprite.play("default")
	MinitonPlayer.play("default")

func _process(delta):
	set_offset(get_offset() + delta * speed)
	if 1.0 - unit_offset < 0.01:
		queue_free()
