extends Node2D
signal attack_ended


func _ready():
	print('running')
	Dialogic.set_variable('spamvil_made_up', GlobalPlotSettings.MADE_UP)
	
	var dialogue = Dialogic.start("spamton_down")
	add_child(dialogue)
	
	await dialogue.timeline_ended
	# все дальнейшие атаки - только Джева
	print('ended running')
	
	emit_signal("attack_ended")


func start_attack():
	print("и тут я начинаю шмалять")
