extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _on_dialogic_signal(params):
	print(params)
	if name == params['character']:
		var player = get_node_or_null("AnimationPlayer")
		if player != null:
			if bool(params.get("reversed") == "true"):
				player.play_backwards(params['animation'])
			else:
				player.play(params['animation'])
		else:
			print('Animation player for dialogic not found')
