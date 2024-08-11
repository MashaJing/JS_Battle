extends Node2D

signal tp_increased
signal tp_decreased

signal action_start
signal action_end
signal offer_deal
signal pacify
signal canceled
signal slow_down_music
signal soundtrack_required(soundtrack)

var cur_decision

var PIRUETT_INDEX = 0
var PIRUETT_OUTCOME = [

	 # увеличение АТК на ход
#	"atk_up",
	
	 # Спам предлагает печеньку, если примешь cookie policy, получаешь печеньку-хилку
	 # (но Спам может теперь видеть содержимое твоего инвентаря? твои решения заранее?)
#	"cookie",

	 # баннер ничего не делает
#	"kangaderro",

	# поменять на TWR (kazoo version) / BIG SHOT (scream version) / нарезать и перемешать оригинальный саундрек
	"soundtrack",

	# послать сигнал ITEM - это лечение сразу, но выглядит как использование хилки Clown juice
#	"clown_juice",

	 # баннер загорается быстро и похож на предыдущий, но увеличивает атк противника на ход :D
#	"atk_up_prompt",

	 # Счастливые часов не наблюдают: следующая атака замедленна на 30%!
#	"slow_mo",

]

func _ready():
	_init_signals()

# вызывается при выборе действия
func start_action(actor, action):
#	1. отправляет сигналы анимашкам, чтобы обозначить готовность
	emit_signal("action_start", actor)
#	2. вычитает TP
	emit_signal("tp_decreased", action.tp_required)


# вызывается при отмене действия (удалении из стека?)
func cancel_action(actor, action):
#	1. отправляет сигналы анимашкам, чтобы вернуть дефолтный вид
	emit_signal("canceled", actor)
#	2. добавляет TP
	emit_signal("tp_increased", action.TP_REQUIRED)


func confirm_action(decision):
	cur_decision = decision
	match cur_decision.ACTION.name:
#	1. отправляют сигналы анимашкам, чтобы применить действие
#	2. шлют сигналы в самые разные узлы, чтобы действие произошло

		'K_ACTION':
			k_action()
		'PIRUETT':
			piruett()
		'OFFER_DEAL':
			offer_deal()

		'S_ACTION':
			s_action()
		'RUDE_BUSTER':
			s_action()

		'R_ACTION':
			r_action()
		'HEAL_PRAYER':
			heal_prayer()
		'PACIFY':
			pacify()
		# ................
		_:
			print("we used")
			print(cur_decision.ACTION.name)
			print("but nothing happened")


func heal_prayer():
	# сколько прибавит?
	DecisionReader.emit_signal("heal", cur_decision.VICTIM, 100)
	_end_action()

func offer_deal():
	_end_action()
	Dialogic.set_variable("offered_deal", 'true')
	emit_signal("offer_deal")

func pacify():
	_end_action()
	emit_signal("pacify", cur_decision.VICTIM)

func k_action():
	_end_action()

func s_action():
	_end_action()

func r_action():
	_end_action()

func _end_action():
	BattleInfoLogger.append_line(cur_decision.DECIDER + ' ' + cur_decision.ACTION.text_on_used)
	emit_signal("action_end", cur_decision.DECIDER)

# ============================== PIRUETT HANDLERS ==============================

func piruett():
	BattleInfoLogger.append_line(cur_decision.DECIDER + ' ' + cur_decision.ACTION.text_on_used)
	emit_signal("action_end", cur_decision.DECIDER, "piruett")

	var outcome = PIRUETT_OUTCOME[PIRUETT_INDEX % len(PIRUETT_OUTCOME)]
	Dialogic.set_variable("piruett", outcome)

	match outcome:
	 # увеличение АТК на ход
		"atk_up":
#			# banner
			BattleInfoLogger.append_line("Awkward! Jevils ATK increases for the next turn!")
#			# TODO: как это передать в основной флоу? можно в BattleInfoLogger и такое прописать
#			# (а можно создать отдельный модуль, отвечающий за катсцены, и передавать туда)
#
#		 # Спам предлагает печеньку, если примешь cookie policy, получаешь печеньку-хилку
#		 # (но Спам может теперь видеть содержимое твоего инвентаря?
#		 # но твои атаки заранее будут известны и он сможет их доджить?)
		"cookie":
#			Dialogic.start("cookie") # диалог про куки
			BattleInfoLogger.append_line("FREE COOKIES")
#
#		 # баннер ничего не делает
		"kangaderro":
			BattleInfoLogger.append_line("It is just a useless kangaderro banner!")
#			var action_dialogue = Dialogic.start("/action_reactions/piruett/attack_increase_banner")
#
#		# поменять на TWR (kazoo version) / BIG SHOT (scream version) / нарезать и перемешать оригинальный саундрек
		"soundtrack":
			BattleInfoLogger.append_line("Something changed...")
			emit_signal("soundtrack_required", "Cucozh.mp3")
#
#		# послать сигнал ITEM - это лечение сразу, но выглядит как использование хилки Clown juice
		"clown_juice":
			BattleInfoLogger.append_line("Cheers! Clown juice to everyone!")
#
#		 # баннер загорается быстро и похож на предыдущий, но увеличивает атк противника на ход :D
		"atk_up_prompt":
			BattleInfoLogger.append_line("QUICKLY CLICK THE BANNER!")
##			Dialogic.start("/action_reactions/piruett/attack_increase_banner")

		 # Счастливые часов не наблюдают: следующая атака замедленна на 30%
		"slow_mo":
			BattleInfoLogger.append_line("Next attack is slowed down on 30%")
			Engine.set_time_scale(0.6)
			emit_signal("slow_down_music")
	


func _init_signals():
	connect("tp_increased", TeamStats, "_on_tp_increased")
	connect("tp_decreased", TeamStats, "_on_tp_decreased")
