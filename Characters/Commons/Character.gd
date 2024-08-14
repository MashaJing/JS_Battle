extends Node2D


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	$PlayerStats.connect("Down", Callable($AnimatedSpriteController, "_on_Down"))
	$PlayerStats.connect("Up", Callable($AnimatedSpriteController, "_on_Up"))
	# обработка хила и дамага сделана по-разному намеренно ввиду различий в этих процессах
	$PlayerStats.connect("TookDamage", Callable($AnimatedSpriteController, "_on_Took_Damage"))

	DecisionReader.connect("healed", _on_get_heal)
	DecisionReader.connect("defended", _on_defend)
#	DecisionReader.connect("spared", _on_spare)
	SpareController.connect("play_spare", _on_spare)
	SpareController.connect("action_start", _on_Action_start)

	ActionsController.connect("action_start", _on_Action_start)
	ActionsController.connect("action_end", _on_Action_end)
	ActionsController.connect("canceled", _on_Up)

	AttackController.connect("attack_start", _on_Action_start)
	AttackController.connect("attack_end", _on_Action_end)
	AttackController.connect("canceled", _on_Up)
	# чисто для соперников
	# AttackController.connect("take_damage", self, "_on_Took_Damage")


func _on_get_heal(_name, delta):
	if name == _name:
		$PlayerStats.heal(delta)
		$AnimatedSpriteController._on_Healed()
		# воспроизведение звука

func _on_defend(_name):
	if name == _name:
		$AnimatedSpriteController._on_Defend()
	var defense_process = $PlayerStats.defend()
	#RIP yield()
	#defense_process.resume()

func _on_spare(_name):
	if name == _name:
		$AnimatedSpriteController._on_Spare()

# up -> action_start
func _on_Action_start(_name, action_animation='action_start'):
	if name == _name:
		$AnimatedSpriteController._on_Action_start(action_animation)

# action_end -> up
func _on_Action_end(_name, action_animation='action'):
	if name == _name:
		$AnimatedSpriteController._on_Action_end(action_animation)

# ... -> up
func _on_Up(_name):
	if name == _name:
		$AnimatedSpriteController._on_Up(_name)

func _on_dialogic_signal(params):
	if name == params['character']:
		var player = get_node_or_null("AnimationPlayer")
		if player != null:
			player.play(params['animation'])
		else:
			print('Animation player for dialogic not found')
