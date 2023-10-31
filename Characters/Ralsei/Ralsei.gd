extends Node2D


func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")

	DecisionReader.connect("heal_ralsei", $PlayerStats, "heal")
	DecisionReader.connect("defend_ralsei", $AnimatedSpriteController, "_on_Defend")
	DecisionReader.connect("spare_ralsei", $AnimatedSpriteController, "_on_Spare")

	ActionsController.connect("ralsei_action_start", $AnimatedSpriteController, "_on_Action_start")
	ActionsController.connect("ralsei_action_end", $AnimatedSpriteController, "_on_Action_end")
