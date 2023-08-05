extends Node2D
var sign_regex = RegEx.new()
onready var TestTimer = $Timer
onready var PasswordField = $PasswordField
onready var TImeBar = $ProgressBar

enum TestPhase {
	CREATE = 0,
	CHECK,
}
export(TestPhase) var currentPhase = TestPhase.CREATE


func _ready():
	match currentPhase:
		TestPhase.CREATE:
			create_pwd_scenario()
		TestPhase.CHECK:
			check_pwd_scenario()
	
#	сделать нормальный чек блеать
	sign_regex.compile("[A-Za-z0-9]{1}$")


func create_pwd_scenario():
	$Spamton/AnimatedSprite.play("default")
	$Spamton.speak("H3Y JEV! [WATCH NOW] AND [learn]!")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("KR KRIS! LET'S [play] A SIMPLE [guessing game]")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("IF YOU SAY U HAD A [bank account]...")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("& TH3RE WAS A [password]...")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("[WAT] WOULD I7 BE?")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("[please respond]")
	yield($Spamton, "stopped_talk")
	PasswordField.text = ''
	PasswordField.visible = true
	TImeBar.visible = true
	$Timer.start()


func check_pwd_scenario():
	$Spamton/AnimatedSprite.play("default")
	$Spamton.speak("H3Y KRIS! DO U REMEMBER [our little secret]?")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("[ofc] YOU DO!")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("NOW S YOUR CHANCE TO...")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("CHECK YOUR [memory]")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("[password, please]")
	yield($Spamton, "stopped_talk")
	PasswordField.text = ''
	PasswordField.visible = true
	TImeBar.visible = true

	$Timer.start()


func _input(event):
	if event is InputEventKey and event.is_pressed():
		var key_text = OS.get_scancode_string(event.scancode)
		print(key_text)
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

func _on_Timer_timeout():
	# этого хватит?
	PasswordField.release_focus()
	PasswordField.visible = false
	TImeBar.visible = false

	match currentPhase:
		TestPhase.CREATE:
			create_pwd_scnario_end()
		TestPhase.CHECK:
			check_pwd_scnario_end()


func create_pwd_scnario_end():
	Password.VALUE = PasswordField.text

	if verificate_password(PasswordField.text):
		$Spamton/AnimatedSprite.play("laugh")
		$Spamton.speak("[GOOD] J0B !!!")
		yield($Spamton, "stopped_talk")
		$Spamton.speak("1 W1LL [Save] YOUR SECRET")
		yield($Spamton, "stopped_talk")
		$Spamton/AnimatedSprite.play("default")
		$Spamton.speak("[for future use]")
	else:
		$Spamton/AnimatedSprite.play("black_glasses")
		$Spamton.speak("[bad] J0B !!!")
		yield($Spamton, "stopped_talk")
		$Spamton.speak("AR U [serious]?! IT DOSNT EVEN [contain at least 8 characters]")
		yield($Spamton, "stopped_talk")


func check_pwd_scnario_end():
	if validate_password(PasswordField.text):
		$Spamton/AnimatedSprite.play("laugh")
		$Spamton.speak("[GREAT] J0B !!!")
		yield($Spamton, "stopped_talk")
		$Spamton.speak("U WON A [specil] PRIZE")
		yield($Spamton, "stopped_talk")
	else:
		$Spamton/AnimatedSprite.play("black_glasses")
		$Spamton.speak("[WAaT]?! U F0RG0T IT?!")
		yield($Spamton, "stopped_talk")
		if len(Password.VALUE) > 8:
			$Spamton.speak("BUT...")
			yield($Spamton, "stopped_talk")
			$Spamton.speak("1T WAS SO [reliable]...")
		else:
			$Spamton.speak("THAT  [micro] PASSWORD U CREATED [2 min] AGO ?1?!")
		yield($Spamton, "stopped_talk")


func _process(delta):
	TImeBar.value = TestTimer.time_left
