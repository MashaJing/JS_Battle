extends PathFollow2D

export var flipped = false
onready var Miniton = $Miniton
#onready var MinitonPlayer = $Miniton/AnimationPlayer
onready var MinitonSprite = $Miniton/Miniton/AnimatedSprite


func _ready():
	if flipped:
		Miniton.scale *= Vector2(-1, -1) 
#	MinitonPlayer.play("default")

func _process(delta):
	set_offset(get_offset() + delta * Miniton.speed)
	if 1.0 - unit_offset < 0.01:
		queue_free()
