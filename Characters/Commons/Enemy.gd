extends Node2D


func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	# обработка хила и дамага сделана по-разному намеренно ввиду различий в этих процессах
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")

	DecisionReader.connect("heal", self, "_on_get_heal")
	DecisionReader.connect("defend", self, "_on_defend")
	DecisionReader.connect("spare", self, "_on_spare")

	ActionsController.connect("action_start", self, "_on_Action_start")
	ActionsController.connect("action_end", self, "_on_Action_end")


# ----------------- passive -----------------

func _on_get_heal(_name, delta):
	if name == _name:
		print('==============YAPEEE============')
		print(' it is ')
		print(name)
		print('==============YAPEEE============')
		$PlayerStats.heal(delta)
		$AnimatedSpriteController._on_Healed()
		# воспроизведение звука


func _on_spare(_name):
	emit_signal("spared")
	if name == _name:
		$AnimatedSpriteController._on_Spare()
