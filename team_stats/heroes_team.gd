extends Node

onready var inventorium = $Inventorium

var MAX_TP = 100
var TP = 100
var tp_delta = 10

# как-то прокинуть хп каждого? Или прям тут? Мб сделать 2 глобальных узла для каждой из сторон?
# можно, чтоб каждая посылала свой сигнал о проигрыше + считать у нас уровень насилия?

const all_heroes = ["Kris", "Susie", "Ralsei"]  # все участники битвы с нашей стороны
var heroes = ["Kris", "Susie", "Ralsei"]  # живые
var individual_stats = {}


var AttackTargets = []
signal game_over


class HeroSorter:
	static func sort(a, b):
		if all_heroes.find(a) < all_heroes.find(b):
			return true
		return false


# обработка сигнала take damage:
	# TargetEnemy получает дамаг в размере из статы
	# Итерируемся по каждому из target-героев (сделать каждому отдельный узел?)
	# и шлём сигнал герой.down, чтобы в меню и выборе следующей цели он пропускался


func _on_take_damage():
	for target in AttackTargets:
		print('teamstats caught signal: take_damage')
		print(target)
		# TODO: атаку прокинуть в зависимости от пули
		get_parent().get_node("Main").get_node(target).get_node("PlayerStats").take_damage(ConStats.ATK)


# TP для всех общий, поэтому он тут
func _on_tp_increased():
	print('ENTERED!')
	TP += tp_delta
	if TP > MAX_TP:
		TP = MAX_TP
	print("TP: ", TP)


func _on_tp_decreased(tp_spent):
	print('_________TP DECREASED!_________')
	TP -= tp_spent
	if TP < 0:
		TP = 0
	print("TP: ", TP)


# мб сразу в ридере и вызывать?
func _on_defend(defender):
	defender.defend()

func _on_ally_down(ally):
	heroes.erase(ally)
	DecisionStack.MAX_SIZE = len(TeamStats.heroes)
	if len(heroes) == 0:
		emit_signal("game_over")
	print(' ^^^^^^^^^^^')
	print(ally + ' is down, so these are left: ')
	print(heroes)


func _on_ally_up(ally):
# 	либо делать через енам или кастомный класс, из которого вытаскивается индекс
#	либо выделываться с этим: var hero_ind = all_heroes.find(ally)
	heroes.append(ally)
	heroes.sort_custom(HeroSorter, "sort")
	DecisionStack.MAX_SIZE = len(TeamStats.heroes)


func choose_target(targets = null) -> void:
	if targets == null:
		AttackTargets = [heroes[randi() % len(heroes)]]
		print('AttackTargets')
		print(AttackTargets)
	else:
		AttackTargets = targets

func get_next_hero(current_hero):
	var hero_ind = heroes.find(current_hero) + 1
	if hero_ind < len(heroes):
		return heroes[hero_ind]
	return null

func get_previous_hero(current_hero):
	var hero_ind = heroes.find(current_hero) - 1
	if hero_ind >= 0:
		return heroes[hero_ind]


func reset():
	heroes = all_heroes.duplicate() # deep?
	for hero in heroes:
		var hero_stats = get_parent().get_node("Main").get_node(hero).get_node("PlayerStats")
		hero_stats.HP = hero_stats.MAX_HP
	TP = 0
	Inventorium.reset()
		
#func get_stats_by_name(_name):
#	 return get_parent().get_node("Main").get_node(_name).get_node("PlayerStats")
