# Menu -> DecisionReader -> Jevil -> ConStats
extends Node2D

var ATK = 1
var DEF = 1

# запускаем пересчёт каждый раз, когда кто-то хилится/отхватывает
var SUM_HP = 2


var enemies_team = {
#	'JEVIL': get_node("/root/TeamStats")
}



func _on_take_damage(victim, damage):
	enemies_team[victim].take_damage(damage)


func _on_heal_Jevil(hp_delta):
	pass
