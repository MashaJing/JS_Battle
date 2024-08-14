extends PathFollow2D

@export var flipped = false
@onready var Miniton = $Miniton
#onready var MinitonPlayer = $Miniton/AnimationPlayer
@onready var MinitonSprite = $Miniton/Miniton/AnimatedSprite2D


func _ready():
	if flipped:
		Miniton.scale *= Vector2(-1, -1) 
#	MinitonPlayer.play("default")

func _process(delta):
	set_progress_ratio(get_progress_ratio() + delta * Miniton.speed)
	if 1.0 - progress_ratio < 0.01:
		queue_free()
