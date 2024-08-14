extends AudioStreamPlayer2D


func play( from_position=0.0 ):
	if !playing:
		super.play(from_position)
	else:
		var asp = self.duplicate(DUPLICATE_USE_INSTANCING)
		get_parent().add_child(asp)
		asp.stream = stream
		asp.play()
		await asp.finished
		asp.queue_free()
