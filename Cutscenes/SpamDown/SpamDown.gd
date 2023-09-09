extends Node2D
signal attack_ended


func _ready():
	print('running')
	GlobalAttackSettings.MADE_UP = false
	Dialogic.set_variable('spamvil_made_up', GlobalAttackSettings.MADE_UP)
	
	var dialogue = Dialogic.start("spamton_down")
	add_child(dialogue)
	
	yield(dialogue, 'dialogic_signal')
	# все дальнейшие атаки - только Джева
	print('ended running')
	
	emit_signal("attack_ended")


func start_attack():
	print("и тут я начинаю шмалять")
