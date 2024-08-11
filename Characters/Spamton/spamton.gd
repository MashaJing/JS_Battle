extends Node

#var MERCY = 0
#
#
#func _ready():
#	$PlayerStats.connect("Down", $AnimatedSpriteController, "_on_Down")
#	$PlayerStats.connect("Up", $AnimatedSpriteController, "_on_Up")
#	$PlayerStats.connect("Healed", $AnimatedSpriteController, "_on_Healed")
#	$PlayerStats.connect("TookDamage", $AnimatedSpriteController, "_on_Took_Damage")
#
#	AttackController.connect("attacked", $PlayerStats, "take_damage")
#
#	ActionsController.connect("offer_deal", self, "_on_offered_deal")
#	ActionsController.connect("pacify", self, "_on_pacify")
#
#
#func _on_offered_deal():
#	MERCY += 10
#
#
#func _on_pacify():
#	print('YOU TRIED TO PACIFY SPAMTON BUUT')
