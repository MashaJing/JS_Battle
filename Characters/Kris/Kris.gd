extends Node2D

func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")

	DecisionReader.connect("heal_kris", $PlayerStats, "heal")
	DecisionReader.connect("defend_kris", $AnimatedSpriteController, "_on_Defend")
	DecisionReader.connect("spare_kris", $AnimatedSpriteController, "_on_Spare")

	ActionsController.connect("kris_action_start", $AnimatedSpriteController, "_on_Action_start")
	ActionsController.connect("kris_action_end", $AnimatedSpriteController, "_on_Action_end")
