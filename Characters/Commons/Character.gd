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


func _on_get_heal(_name, delta):
	if name == _name:
		print('==============YAPEEE============')
		print(' it is ')
		print(name)
		print('==============YAPEEE============')
		$PlayerStats.heal(delta)
		$AnimatedSpriteController._on_Healed()
		# воспроизведение звука

func _on_defend(_name):
	if name == _name:
		$AnimatedSpriteController._on_Defend()

func _on_spare(_name):
	if name == _name:
		$AnimatedSpriteController._on_Spare()

# action_start -> up
func _on_Action_start(_name):
	print(_name)
	print(name)
	if name == _name:
		$AnimatedSpriteController._on_Action_start()

# action_end -> up
func _on_Action_end(_name, action_animation='action'):
	if name == _name:
		$AnimatedSpriteController._on_Action_end(action_animation)
