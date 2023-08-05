extends Node

signal attck_begins
signal decided
signal canceled

# тоже типа стейт-машина?
enum State {
	CLOSED,
	KRIS_TURN,
	SUSIE_TURN,
	RALSEI_TURN,
}

var state = State.CLOSED
var Decision = preload("res://Stats/DecisionMessage/DecisionMessage.tscn")


func open_menu():
	$AnimationPlayer.play("kris_turn")
	state = State.KRIS_TURN
	$AnimationPlayer.handle_state(State.KRIS_TURN)

func switch_to_susie_from_kris():
	# лучше вынести, чтобы animationplayer не повторялся
	# внутри плеера сделать свитч, при вызове сметода делать update стейта
	# свитч внутри плеера ведет себя по стейту
	$AnimationPlayer.play("kris_turn", -1, 1.0, true)
	$AnimationPlayer.play("susie_turn")
	state = State.SUSIE_TURN

func switch_to_susie_from_ralsei():
	$AnimationPlayer.play("ralsei_turn", -1, 1.0, true)
	$AnimationPlayer.play("susie_turn")
	state = State.SUSIE_TURN

func switch_to_kris():
	$AnimationPlayer.play("susie_turn", -1, 1.0, true)
	$AnimationPlayer.play("kris_turn")
	state = State.KRIS_TURN

func switch_to_ralsei():
	$AnimationPlayer.play("susie_turn", -1, 1.0, true)
	$AnimationPlayer.play("ralsei_turn")
	state = State.RALSEI_TURN

func close_menu():
	$AnimationPlayer.play("ralsei_turn", -1, 1.0, true)
	state = State.CLOSED

# на ентер
func _on_made_turn():
	match state:
		State.CLOSED:
			pass
		State.KRIS_TURN:
			# передавать аргументом решение
			emit_signal("decided")
			switch_to_susie_from_kris()
		State.SUSIE_TURN:
			emit_signal("decided")
			switch_to_ralsei()
		State.RALSEI_TURN:
			emit_signal("decided")
			close_menu()

# на x
func _on_canceled_turn():
	match state:
		State.CLOSED:
			pass
		State.KRIS_TURN:
			pass
		State.SUSIE_TURN:
			switch_to_kris()
			emit_signal("canceled")	
		State.RALSEI_TURN:
			switch_to_susie_from_ralsei()
			# важно помнить, что это отмена хода не Ральзея, а Сьюзи
			emit_signal("canceled")

func _ready():
	while len(DecisionStack.DECISIONS) < 3:
		yield(self, "decided")
	# вызывать ридера
	
#	var team = ['kris', 'susie', 'ralsei']
#	$AnimationPlayer.play("hide_all", -1, 1.0, true)
#	# а как откатывать? -_- стейт-машина!!!
#	for member in team:
#		print(member)
#		yield(self, "decided")
#	call_deferred("emit_signal", "attck_begins")

func _on_decided():
	# choice может собираться из глобальных переменных скрипта,
	# которые устанавливаются по нажатиям на кнопки
	var choice
	# choice обогатить, пихнуть в стек
	DecisionStack.add_decision(choice)
			

func _on_canceled(decision):
	# рассчитываю, что последнее затрется
	DecisionStack.pop_decision()

# вынести в отдельный обработчик, переиспользовать для каждой секции
func _on_Attack_button_down():
	print('Attack button pressed!')
	emit_signal("decided")
	var a = Decision.instance()
	a.TYPE = 'ATTACK'
	DecisionStack.add_decision(a)

func _on_Act_button_down():
	print('Act button pressed!')
	emit_signal("decided")
	var a = Decision.instance()
	a.TYPE = 'ACT'
	DecisionStack.add_decision(a)

func _on_Item_button_down():
	print('Item button pressed!')
	emit_signal("decided")

func _on_Spare_button_down():
	print('Spare button pressed!')
	emit_signal("decided")
	call_deferred("emit_signal", "attck_begins")

func _on_Defense_button_down():
	print('Defense button pressed!')
	emit_signal("decided")


func hide():
	print("menu hidden")
	$AnimationPlayer.play("hide_all")

func unhide():
	print("menu unhidden")
	$AnimationPlayer.play("hide_all", -1, 1.0, true)
