extends Node2D
var sign_regex = RegEx.new()
@onready var TestTimer = $Timer
@onready var PasswordField = $PasswordField
@onready var TImeBar = $ProgressBar
@onready var Shocker = preload("res://Bullets/Shocker/Shocker.tscn")

signal attack_ended


func _ready():
#	сделать нормальный чек блеать
	sign_regex.compile("[A-Za-z0-9]{1}$")
	var dialog_name
	match Password.CUR_TEST_PHASE:
		Password.TestPhase.CREATE:
			dialog_name = "spamton_password_create"
		Password.TestPhase.CHECK:
			dialog_name = "spamton_password_check"

	#var dialog = Dialogic.start(dialog_name)
	#add_child(dialog)
	#await Dialogic.timeline_ended
	emit_signal("attack_ended")


func start_enter():
	PasswordField.text = ''
	PasswordField.visible = true
	TImeBar.visible = true
	$Timer.start()


# закроем, когда отрабатывает таймер
func _on_Timer_timeout():
	# этого хватит?
	PasswordField.release_focus()
	PasswordField.visible = false
	TImeBar.visible = false


func _input(event):
	if event is InputEventKey and event.is_pressed():
		var key_text = OS.get_keycode_string(event.unicode)
		if key_text == "BackSpace":
			var new_text = PasswordField.text
			new_text.erase(PasswordField.text.length()-1,1)
			PasswordField.text = new_text
		elif validate_sign(key_text):
			PasswordField.text += key_text

func validate_sign(s):
	var result = sign_regex.search(s)
	return result != null

func verificate_password(pwd):
	return len(pwd) >= 8

func validate_password(pwd):
	return pwd.to_lower() == Password.VALUE.to_lower()


func create_pwd_end():
	Password.VALUE = PasswordField.text
	Dialogic.set_variable('user_password_len', len(Password.VALUE))
	Password.CUR_TEST_PHASE = Password.TestPhase.CHECK


func check_pwd_end():
	Dialogic.set_variable("user_password_valid", validate_password(PasswordField.text))


func _process(delta):
	TImeBar.value = TestTimer.time_left


func shock_heart():
	var shocker = Shocker.instantiate()
	$KinematicHeart.add_child(shocker)
	await get_tree().create_timer(1.0).timeout
	shocker.free()
