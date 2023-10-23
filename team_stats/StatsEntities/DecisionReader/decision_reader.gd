extends Node2D

var TMP_DEC_LIST = [
	'DEFENSE',
	'ACTION',
	'ITEM',
	'ATTACK',
	'SPARE'
]
#signal defend
signal attack_jevil
signal attack_spamton
signal start_decisions_reading
signal end_decisions_reading

signal heal_kris
signal heal_susie
signal heal_ralsei

# эта группа сигналов шлётся в другом скрипте, но логичнее держать в одном месте
signal defend_kris
signal defend_susie
signal defend_ralsei


# читает стек и шлёт сигналы в разные узлы
func start():
	emit_signal("start_decisions_reading")
	
	# точно должно быть здесь?
	Inventorium.clear_reserved()
	var decision_text = ''
	for i in range(DecisionStack.MAX_SIZE):
		var current_decision = DecisionStack.pop_decision()
		
		match current_decision.TYPE:
			'DEFENSE':
				decision_text = decision_text + '* '+ current_decision.DECIDER + ' defended!\n'
				defense(current_decision)
			'ACTION':
				decision_text = decision_text + '* '+ current_decision.DECIDER + ' used ' + current_decision.ACTION.name + '!\n'
				action(current_decision)
			'ITEM':
				decision_text = decision_text + '* '+ current_decision.VICTIM + ' used ' + current_decision.ITEM.name + '!\n'
				item(current_decision)
			'ATTACK':
				# позже прокинем АТК десайдера, пока кнопка только убивает
				attack(current_decision, 10000)
			'SPARE':
				decision_text = decision_text + '* '+ current_decision.DECIDER + ' spared ' + current_decision.VICTIM + '...\n'
				spare(current_decision)
	
	Dialogic.set_variable("info_line", decision_text)

	# ПЕРЕХОД В МЕНЮ ОБРАТНО
	emit_signal("end_decisions_reading")

func spare(decision):
	emit_signal("spare", decision.DECIDER)


func defense(decision):
	pass


func action(decision):
	match decision.ACTION.name:
		'PIRUETT':
			process_piruett()
		'HYPNOTIZE':
			emit_signal('hypnotize', decision.DECIDER, decision.VICTIM)
		'HEAL_SPELL':
			emit_signal('heal_spell', decision.VICTIM)
		'OFFER_DEAL':
			emit_signal('offer_deal', decision.DECIDER, decision.VICTIM)

		# ................
		_:
			print("we used")
			print(decision.TYPE)
			print("but nothing happened")


func attack(decision, damage):
	 # из действующего лица можно прокинуть значение АТК 3-им аргументом
	print('attacked victim in reader!')
	emit_signal("attack_%s" % decision.VICTIM.to_lower(), damage)


func item(decision):
	emit_signal("heal_%s" % decision.VICTIM.to_lower(), decision.ITEM.hp_delta)


func process_piruett():
	# я блять вообще без понятия
	pass
