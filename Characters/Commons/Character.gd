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
	ActionsController.connect("canceled", $AnimatedSpriteController, "_on_Up")

	AttackController.connect("attack_start", self, "_on_Action_start")
	AttackController.connect("attack_end", self, "_on_Action_end")
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
	yield()
	defense_process.resume()

func _on_spare(_name):
	if name == _name:
		$AnimatedSpriteController._on_Spare()

# up -> action_start
func _on_Action_start(_name, action_animation='action'):
	if name == _name:
		$AnimatedSpriteController._on_Action_start(action_animation)

# action_end -> up
func _on_Action_end(_name, action_animation='action'):
	if name == _name:
		$AnimatedSpriteController._on_Action_end(action_animation)
