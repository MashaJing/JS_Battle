extends Node2D


func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")

	DecisionReader.connect("heal_ralsei", $PlayerStats, "heal")
	DecisionReader.connect("defend_ralsei", $AnimatedSpriteController, "_on_Defend")
