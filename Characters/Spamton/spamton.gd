extends Node


func _ready():
	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")
	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")

	$PlayerStats.connect("Down", GlobalAttackSettings, "_on_spam_down")
	DecisionReader.connect("attack_spamton", $PlayerStats, "take_damage")
