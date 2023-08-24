extends Node2D

var ATK = 1
var DEF = 1

# запускаем пересчёт каждый раз, когда кто-то хилится/отхватывает
var SUM_HP = 2


# обрабатывает сигнал атаки из decisionReader
func _on_take_damage(victim):
	victim.take_damage()


func _on_heal_Jevil(hp_delta):
	pass

