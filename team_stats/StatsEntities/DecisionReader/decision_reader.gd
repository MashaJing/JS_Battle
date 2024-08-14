extends Node2D

signal start_decisions_reading
signal end_decisions_reading

signal attacked

# описать реакции на действия source/receiver: start_attack / receive_attack
# все реакции на действия реализованы внутри получателей
# heal(kris) - глобальный эммитер по 1 аргументу поймёт, кому переслать
# логгер слушает глобальный эммитер, логгер не сильно умный
signal healed(_name, hp_delta)
signal defended(_name)
#signal spare(_name)

func _ready():
	pass


# читает стек и шлёт сигналы в разные узлы
func start():
	emit_signal("start_decisions_reading")
	
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
#	emit_signal("spared", decision.DECIDER, decision.VICTIM)
	SpareController.confirm_spare(decision.DECIDER, decision.VICTIM)
	BattleInfoLogger.append_line(decision.DECIDER + ' spared ' + decision.VICTIM)


func defense(decision):
	# минует стек, т.к. действие мгновенное
	pass

func action(decision):
#	обращение в глобальный обработчик действий
	ActionsController.confirm_action(decision)


func attack(decision):
	pass
	 # из действующего лица можно прокинуть значение АТК 3-им аргументом
	print('++++++++++++++++++++++++++++++++++++++++++++++')
	print('attacked victim in reader!')
	print('++++++++++++++++++++++++++++++++++++++++++++++')
#	emit_signal("attacked", decision.DECIDER, decision.VICTIM)


func item(decision):
	BattleInfoLogger.append_line(decision.VICTIM + ' used ' + decision.ITEM.name)
	emit_signal("healed", decision.VICTIM, decision.ITEM.hp_delta)
