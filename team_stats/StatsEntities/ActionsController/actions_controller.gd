extends Node2D

signal tp_increased
signal tp_decreased

signal action_start
signal action_end
signal offer_deal
signal pacify

var cur_decision

var PIRUETT_OUTCOME = [

	 # увеличение АТК на ход
	"atk_up",
	
	 # Спам предлагает печеньку, если примешь cookie policy, получаешь печеньку-хилку
	 # (но Спам может теперь видеть содержимое твоего инвентаря? твои решения заранее?)
	"cookie",

	 # баннер ничего не делает
	"kangaderro",

	# поменять на TWR (kazoo version) / BIG SHOT (scream version) / нарезать и перемешать оригинальный саундрек
	"soundtrack",

	# послать сигнал ITEM - это лечение сразу, но выглядит как использование хилки Clown juice
	"clown_juice",

	 # баннер загорается быстро и похож на предыдущий, но увеличивает атк противника на ход :D
	"atk_up_prompt",

	 # Счастливые часов не наблюдают: следующая атака замедленна на 30%!
	"slow_mo",

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
	emit_signal("Up", actor)
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

	var outcome = PIRUETT_OUTCOME[GlobalAttackSettings.CUR_ATTACK_IND % len(PIRUETT_OUTCOME)]
	Dialogic.set_variable("piruett", outcome)


func _init_signals():
	connect("tp_increased", TeamStats, "_on_tp_increased")
	connect("tp_decreased", TeamStats, "_on_tp_decreased")
