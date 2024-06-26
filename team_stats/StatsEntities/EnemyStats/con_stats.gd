# Menu -> DecisionReader -> Jevil -> ConStats
extends Node2D

var ATK = 1
var DEF = 1

# запускаем пересчёт каждый раз, когда кто-то хилится/отхватывает
var SUM_HP = 4

var allies = ["Jevil", "Spamton"]
var individual_stats = {}


func _ready():
	pass

func _on_take_damage(victim, damage):
	individual_stats[victim].take_damage(damage)

# нужно в GlobalAttackSettings как условие перехода в след фазу
func compare_hp(threshold):
	print(threshold)
	print('compared to')
	print(SUM_HP)
	return SUM_HP <= threshold
	
