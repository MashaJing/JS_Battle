extends Node2D

var BATTLE_INFO = []


# BattleInfoLogger - глобальный модуль, который получает изменения состояний и выписывает это в диалоджик
func append_line(replica):
	if len(BATTLE_INFO) < 3:
		BATTLE_INFO += ['* ' + replica + '\n']


func get_lines():
	var battle_info_string = ""
	for line in BATTLE_INFO:
		battle_info_string += line
	return battle_info_string


func clear():
	BATTLE_INFO.clear()


func show_dialogue():
	Dialogic.set_variable("info_line", get_lines())
	if len(BATTLE_INFO) > 0:
		return Dialogic.start("battle_info")
