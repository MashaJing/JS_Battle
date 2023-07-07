extends Node

signal attck_begins
signal decided


func _ready():
	print('menu is ready!')
	var team = ['kris', 'susie', 'ralsei']
	$AnimationPlayer.play("hide_all")

	# а как откатывать? -_-
	for member in team:
		$AnimationPlayer.play("{m}_turn".format({'m': member}))
		print(member)
		yield(self, "decided")
		$AnimationPlayer.play("{m}_turn".format({'m': member}), -1, 1.0, true)

	call_deferred("emit_signal", "attck_begins")
	hide()

func _on_Attack_button_down():
	print('Attack button pressed!')
	emit_signal("decided")

func _on_Act_button_down():
	print('Act button pressed!')
	emit_signal("decided")

func _on_Item_button_down():
	print('Item button pressed!')
	
	emit_signal("decided")

func _on_Spare_button_down():
	print('Spare button pressed!')
	emit_signal("decided")

func _on_Defense_button_down():
	print('Defense button pressed!')
	emit_signal("decided")


func hide():
	print("menu hidden")
	$AnimationPlayer.play("hide")
