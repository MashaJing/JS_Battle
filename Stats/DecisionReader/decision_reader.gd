extends Node2D

var TMP_DEC_LIST = [
	'DEFENSE',
	'ACTION',
	'ITEM',
	'ATTACK',
	'SPARE'
]
signal defend
signal attack


# читает стек и шлёт сигналы в разные узлы
func start():
	for i in range(DecisionStack.MAX_SIZE):
		var current_decision = DecisionStack.pop_decision()
		
		# Вывести в меню текст о решении '* Сьюзи чем-то покрутила'
		print("* {DECIDER} {TURN_DECISION}")
		
		match current_decision.TYPE:
			'DEFENSE':
				defense(current_decision)
			'ACTION':
				action(current_decision)
			'ITEM':
				item(current_decision)
			'ATTACK':
				attack(current_decision)
			'SPARE':
				spare(current_decision)
		yield() # Enter (пролистать реплику дальше)

	# ПЕРЕХОД В ФАЗУ АТАКИ

func spare(decision):
	emit_signal("spare", decision.DECIDER)


func defense(decision):
	emit_signal("defend", decision.DECIDER)


func action(decision):
	match decision.TYPE:
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


func attack(decision):
	emit_signal("attack", decision.VICTIM)


func item(decision):
	Inventorium.pop_item(decision.ITEM_CODE)
	emit_signal("heal", decision.VICTIM)


func process_piruett():
	pass
