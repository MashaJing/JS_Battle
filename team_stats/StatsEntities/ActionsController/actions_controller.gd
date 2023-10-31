extends Node2D

signal tp_increased
signal tp_decreased

signal kris_action_start
signal susie_action_start
signal ralsei_action_start

signal kris_action_end
signal susie_action_end
signal ralsei_action_end

# нужно тут или action достаточно?
var cur_decision

var PIRUETT_OUTCOME = [
	 # увеличение АТК на ход
	"increase_atk",

	 # баннер ничего не делает
	"useless_kangaderro",

	 # баннер загорается быстро, если успеваешь принять cookie policy, получаешь печеньку-хилку
	 # (но Спам может теперь видеть содержимое твоего инвентаря? твои решения заранее?)
	"cookie_banner",

	 # баннер загорается быстро и похож на предыдущий, но увеличивает атк противника на ход :D
	"increase_atk_banner",
	 # Счастливые часов не наблюдают: следующая атака замедленна на 30%!
	 # (не имба ли? можно сделать 1 атаку наоборот настолько быстрой, что без пируэта её не пройти)
	"slow_mo",

	# поменять на ремикс крутой песни Папируса / TWR (kazoo version) / BIG SHOT (scream version)
	"change_soundtrack",

	# послать сигнал ITEM - это лечение сразу, но выглядит как использование хилки Clown juice
	"heal"
]

func _ready():
	connect("tp_increased", TeamStats, "_on_tp_increased")
	connect("tp_decreased", TeamStats, "_on_tp_decreased")

# вызывается при выборе действия
func start_action(actor, action):
#	1. отправляет сигналы анимашкам, чтобы обозначить готовность
	emit_signal(actor + "_action_start")

#	2. вычитает TP
	emit_signal("tp_decreased", action.tp_required)


# вызывается при отмене действия (удалении из стека?)
func cancel_action(action):
#	1. отправляет сигналы анимашкам, чтобы вернуть дефолтный вид
#	2. добавляет TP
	emit_signal("tp_increased", action.TP_REQUIRED)


func confirm_action(decision):
	cur_decision = decision
	match cur_decision.ACTION.name:
#	1. отправляют сигналы анимашкам, чтобы применить действие
#	2. шлют сигналы в самые разные узлы, чтобы действие произошло

		'PIRUETT':
			piruett()
		'OFFER_DEAL':
			offer_deal()
		'HEAL_PRAYER':
			heal_prayer()
		'PACIFY':
			pacify()
		'S_ACTION':
			s_action()

		# ................
		_:
			print("we used")
			print(name)
			print("but nothing happened")



func offer_deal():
	pass


func piruett():
	emit_signal(cur_decision.DECIDER + "_action_end", "piruett")
	var outcome = PIRUETT_OUTCOME[GlobalAttackSettings.CUR_ATTACK_IND % len(PIRUETT_OUTCOME)]
	print(outcome)

	match outcome:
		"increase_atk":
			pass

		"useless_kangaderro":
			pass
		
		"cookie_banner":
			pass
		
		"increase_atk_banner":
			pass

		"slow_mo":
			pass

		"change_soundtrack":
			pass

		"heal":
			pass

func heal_prayer():
	# сколько прибавит?
	DecisionReader.emit_signal("heal_%s" % cur_decision.VICTIM.to_lower(), 100)

func cookie_banner():
	pass

func pacify():
	emit_signal(cur_decision.DECIDER + "_action_end")

func s_action():
	emit_signal(cur_decision.DECIDER + "_action_end")
