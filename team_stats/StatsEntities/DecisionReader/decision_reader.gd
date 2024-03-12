extends Node2D

var TMP_DEC_LIST = [
	'DEFENSE',
	'ACTION',
	'ITEM',
	'ATTACK',
	'SPARE'
]

signal start_decisions_reading
signal end_decisions_reading

#signal attack_jevil
#signal attack_spamton
signal attack

# описать реакции на действия source/receiver: start_attack / receive_attack
# все реакции на действия реализованы внутри получателей
# heal(kris) - глобальный эммитер по 1 аргументу поймёт, кому переслать
# логгер слушает глобальный эммитер, логгер не сильно умный
signal heal(_name, hp_delta)
signal defend(_name)
signal spare(_name)


# читает стек и шлёт сигналы в разные узлы
func start():
	emit_signal("start_decisions_reading")
	
	# точно должно быть здесь?
	Inventorium.clear_reserved()

	var decision_text = ''
	for decision in DecisionStack.DECISIONS:
		print(decision.TYPE)
		
	for i in range(len(DecisionStack.DECISIONS)):
		var current_decision = DecisionStack.pop_decision()
		match current_decision.TYPE:
			'DEFENSE':
				defense(current_decision)
			'ACT':
				action(current_decision)
				# + additional_text ("Атака Д. уменьшилась!") - идет доп полем в решении
			'ITEM':
				decision_text = decision_text + ' used ' + current_decision.ITEM.name + '!\n'
				item(current_decision)
			'ATTACK':
				attack(current_decision)
			'SPARE':
				decision_text = decision_text + ' spared ' + current_decision.VICTIM + '...\n'
				spare(current_decision)

	# ПЕРЕХОД В МЕНЮ ОБРАТНО
	emit_signal("end_decisions_reading")


func spare(decision):
	# в con_stats реализовать обработчик сигнала пощады - там будет проверяться возможность пощады (и готовность в %)
	emit_signal("spare", decision.DECIDER, decision.VICTIM)
	BattleInfoLogger.append_line(decision.DECIDER + ' spare ' + decision.VICTIM)


func defense(decision):
	emit_signal("defend", decision.DECIDER)


func action(decision):
#	обращение в глобальный обработчик действий
	ActionsController.confirm_action(decision)


func attack(decision):
	 # из действующего лица можно прокинуть значение АТК 3-им аргументом
	print('attacked victim in reader!')
	# позже прокинем АТК десайдера, пока кнопка только убивает
	emit_signal("attack", decision.VICTIM, 100000)


func item(decision):
	BattleInfoLogger.append_line(decision.VICTIM + ' used ' + decision.ITEM.name)
	emit_signal("heal", decision.VICTIM, decision.ITEM.hp_delta)
