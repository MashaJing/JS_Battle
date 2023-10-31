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

signal attack_jevil
signal attack_spamton

signal heal_kris
signal heal_susie
signal heal_ralsei

signal defend_kris
signal defend_susie
signal defend_ralsei

signal spare_kris
signal spare_susie
signal spare_ralsei


# читает стек и шлёт сигналы в разные узлы
func start():
	emit_signal("start_decisions_reading")
	
	# точно должно быть здесь?
	Inventorium.clear_reserved()

	var decision_text = ''
	for i in range(DecisionStack.MAX_SIZE):
		var current_decision = DecisionStack.pop_decision()
		decision_text = decision_text + '* '+ current_decision.DECIDER
		match current_decision.TYPE:
			'DEFENSE':
				decision_text = decision_text + ' defended!\n'
				defense(current_decision)
			'ACT':
				decision_text = decision_text + ' ' + current_decision.ACTION.text_on_used + '!\n'
				action(current_decision)
				# + additional_text ("Атака Д. уменьшилась!") - идет доп полем в решении
			'ITEM':
				decision_text = decision_text + ' used ' + current_decision.ITEM.name + '!\n'
				item(current_decision)
			'ATTACK':
				# позже прокинем АТК десайдера, пока кнопка только убивает
				attack(current_decision, 10000)
			'SPARE':
				decision_text = decision_text + ' spared ' + current_decision.VICTIM + '...\n'
				spare(current_decision)
	
	Dialogic.set_variable("info_line", decision_text)

	# ПЕРЕХОД В МЕНЮ ОБРАТНО
	emit_signal("end_decisions_reading")

func spare(decision):
	# в con_stats реализовать обработчик сигнала пощады - там будет проверяться возможность пощады (и готовность в %)
	emit_signal("spare_" + decision.DECIDER, decision.VICTIM)


func defense(decision):
	emit_signal("defend_" + decision.DECIDER)


func action(decision):
#	обращение в глобальный обработчик действий, который занимается всем менеджментом действий
	ActionsController.confirm_action(decision)


func attack(decision, damage):
	 # из действующего лица можно прокинуть значение АТК 3-им аргументом
	print('attacked victim in reader!')
	emit_signal("attack_%s" % decision.VICTIM.to_lower(), damage)


func item(decision):
	emit_signal("heal_%s" % decision.VICTIM.to_lower(), decision.ITEM.hp_delta)
