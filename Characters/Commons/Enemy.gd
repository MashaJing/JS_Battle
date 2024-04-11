extends Node2D


func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	# обработка хила и дамага сделана по-разному намеренно ввиду различий в этих процессах
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")
#	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")

#	DecisionReader.connect("heal", self, "_on_get_heal")
#	DecisionReader.connect("defend", self, "_on_defend")
#	DecisionReader.connect("spare", self, "_on_spare")

#	ActionsController.connect("action_start", self, "_on_Action_start")
#	ActionsController.connect("action_end", self, "_on_Action_end")

#	AttackController.connect("attack_start", self, "_on_Action_start")
#	AttackController.connect("attack_end", self, "_on_Action_end")
	AttackController.connect("attack", $PlayerStats, "take_damage")
	$PlayerStats.connect("Down", GlobalAttackSettings, "_on_spam_down")

# ----------------- passive -----------------

func _on_get_heal(_name, delta):
	if name == _name:
		$PlayerStats.heal(delta)
		$AnimatedSpriteController._on_Healed()
		# воспроизведение звука


func _on_spare(_name):
	emit_signal("spared")
	if name == _name:
		$AnimatedSpriteController._on_Spare()
