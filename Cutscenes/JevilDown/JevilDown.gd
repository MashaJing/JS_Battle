extends Node2D


func parse_ip(ip_addr):
	var ip_arr = ip_addr[0].split("\n")
	# в конце совпадает с другими источниками
	ip_arr.invert()
	for property in ip_arr:
		if "Address" in property:
			property = property.substr(property.find("Address: ") + 10)
			return property.strip_edges(true, true)

	# обработать
	return "0"


func prepare_user_name():
	var dir_addr = OS.get_data_dir()
	var addr_array = dir_addr.split("/")
	
	# далеко не лучший способ итерироваться по массиву, мб найду другой
	for dir_i in len(addr_array):
		if addr_array[dir_i] == "Users":
			return addr_array[dir_i + 1]
	return '[little sponge]'


func prepare_user_ip():
	var ip_addr = []
	var exit_code = OS.execute("nslookup", ["myip.opendns.com.", "resolver1.opendns.com"], true, ip_addr)
	if exit_code == 0:
		ip_addr[0].find("IPv4")
		return parse_ip(ip_addr)
	else:
		return "-1"


func check_ip(ip):
	if ip != "127.0.0.1" and ip.is_valid_ip_address():
		return true


func _ready():
	
	var user_name = prepare_user_name()
	var user_ip = prepare_user_ip()

	$Spamton/AnimatedSprite.play("turn_back")
	$Spamton.speak("!")
	yield($Spamton, "stopped_talk")
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	$Spamton/AnimatedSprite.play("black_glasses")
	$Spamton.speak("Do you think that's funny?")
	yield($Spamton, "stopped_talk")

	
	$Spamton.speak("WE ALREADY HAVE A [Clown Around Town] IN HERE, {user_name}".format({'user_name': user_name}))
	yield($Spamton, "stopped_talk")
	$Spamton/AnimationPlayer.play("default")

	$Spamton.speak("DO U KNOW")
	yield($Spamton, "stopped_talk")
	
	$Spamton.speak("WAT IS WAY [funny]ER?")
	yield($Spamton, "stopped_talk")
	
	if check_ip(user_ip):
		$Spamton.speak("{user_ip}".format({"user_ip": user_ip}), 0.4)
		# без ентера надо бы
		yield($Spamton, "stopped_talk")
		$AnimationPlayer.play("he_is_serious")
		yield($AnimationPlayer, "animation_finished")
		$Spamton/AnimationPlayer.play("laugh")
		
	else:
		$Spamton.speak(" ", 1.0)
		yield($Spamton, "stopped_talk")
		
		$Spamton.speak("WAAT THE!!?")
		yield($Spamton, "stopped_talk")
	
		$Spamton/AnimatedSprite.play("black_glasses")
		
		$Spamton.speak("WHERE'S [all the] WEB? I WANT YOUR   [4 digits with dots]!!")
		yield($Spamton, "stopped_talk")

		$Spamton.speak("WHERE R YOU, [#$@]ER???")
		yield($Spamton, "stopped_talk")

		$Spamton.speak("HOW AM 1 SUPOSED TO [play nice]  WHEN [TOXiC]s LIKE YOU")
		yield($Spamton, "stopped_talk")

		$Spamton.speak("SIT IN THEIR [vault]s")
		yield($Spamton, "stopped_talk")

		$Spamton.speak("AND [git commit] [MASSIVE] GENOCIDE")
		yield($Spamton, "stopped_talk")

		$Spamton.speak("YOU [--force] ME TO CHEAT")
		yield($Spamton, "stopped_talk")

