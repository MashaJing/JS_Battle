extends Node2D


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	$PlayerStats.connect("Down", Callable($AnimatedSpriteController, "_on_Down"))
	$PlayerStats.connect("Down", _on_Down)
	$PlayerStats.connect("Up", Callable($AnimatedSpriteController, "_on_Up"))
	# обработка хила и дамага сделана по-разному намеренно ввиду различий в этих процессах
	$PlayerStats.connect("TookDamage", Callable($AnimatedSpriteController, "_on_Took_Damage"))

	SpareController.connect("play_spare", _on_spare)
	DecisionReader.connect("healed", _on_get_heal)
	
#	DecisionReader.connect("defended", self, "_on_defend")
#	DecisionReader.connect("spared", self, "_on_spare")

#	ActionsController.connect("action_start", self, "_on_Action_start")
#	ActionsController.connect("action_end", self, "_on_Action_end")

#	AttackController.connect("attack_start", self, "_on_Action_start")
#	AttackController.connect("attack_end", self, "_on_Action_end")
	AttackController.connect("attacked", Callable($PlayerStats, "take_damage"))

# ----------------- passive -----------------

func _on_get_heal(_name, delta):
	if name == _name:
		$PlayerStats.heal(delta)
		$AnimatedSpriteController._on_Healed()
		# воспроизведение звука


func _on_spare(_name):
	if name == _name:
		$AnimatedSpriteController._on_Spare()


func _on_Down(_name):
	GlobalAttackSettings.play_enemy_down(_name)

func _on_play_custom_animation(_name, _animation_name):
	if name == _name:
		$AnimationPlayer.play(_animation_name)


func _on_dialogic_signal(params):
	if name == params['character']:
		var player = get_node_or_null("AnimationPlayer")
		if player != null:
			player.play(params['animation'])
		else:
			print('Animation player for dialogic not found')
