extends Node2D

var width_ratio = 1
var height_ratio = 1
var flipped = false

var dialogue_text = ''
signal next_line
signal replica_printed


func resize(width_ratio, height_ratio):
	$DialogueWin.scale()

func _ready():
	if flipped:
		#global_position.x += 300
		position.x += 300
		$DialogueWin.flip_h = true
		$DialogueRoot.flip_h = true
	print('created dialogue!')
	pass

func display(replica, timeout=0.01, pause=0, speak_sound=null):
	$Text/RichTextLabel.visible_characters = 0
	$Text/RichTextLabel.bbcode_text = replica
	$Timer.wait_time = timeout
	print(replica)
	$Timer.start()
	while $Text/RichTextLabel.visible_characters < len(replica):
		$Text/RichTextLabel.visible_characters += 1
		if speak_sound != null:
			speak_sound.play()
			# фигня
			yield($Timer, "timeout")
			speak_sound.stop()
		yield($Timer, "timeout")
	emit_signal("replica_printed")
	# resize(width_ratio, height_ratio)


func _process(_delta):
	if Input.is_action_just_released("Enter"):
		print('signal emmited!')
		emit_signal("next_line")
