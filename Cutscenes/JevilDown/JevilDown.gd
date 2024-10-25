extends Node2D
@onready var MusTheme = get_parent().get_node("Theme")
signal attack_ended


# ============== region and country ==============
func prepare_user_region(user_ip):
	$HTTPRequest.connect("request_completed", _on_request_completed)
	$HTTPRequest.request("http://demo.ip-api.com/json/" + user_ip)
	print('------------------------prepared!------------------------')



func _on_request_completed(result, response_code, headers, body):
	print(body)
	print(typeof(body))
	var test_json_conv = JSON.new()
	var s = test_json_conv.parse(body.get_string_from_utf8())
	print(s)
	
	var json = test_json_conv.get_data()
	# TODO: обработать случаи, когда апишка не отдаёт эти поля
	Dialogic.VAR.user_country = json['country']
	Dialogic.VAR.user_region = json['regionName']
	
	
# =================== name ========================
func prepare_user_name():
	var dir_addr = OS.get_data_dir()
	var addr_array = dir_addr.split("/")
	
	# далеко не лучший способ итерироваться по массиву, мб найду другой
	for dir_i in len(addr_array):
		if addr_array[dir_i] == "Users":
			return addr_array[dir_i + 1]
	return '[little sponge]'


# ==================== ip ==========================
func parse_ip(ip_addr):
	var ip_arr = ip_addr[0].split("\n")
	# в конце совпадает с другими источниками ✔
	ip_arr.reverse()
	for property in ip_arr:
		if "Address" in property:
			property = property.substr(property.find("Address: ") + 10)
			return property.strip_edges(true, true)
	return "0"

func check_ip(ip):
	if ip != "127.0.0.1" and ip.is_valid_ip_address():
		return true

func prepare_user_ip():
	var ip_addr = []
	var command_output = []
	var exit_code = OS.execute("nslookup", ["myip.opendns.com.", "resolver1.opendns.com"], ip_addr)
	print(command_output)
	if exit_code == 0:
		ip_addr[0].find("IPv4")
		var resulting_ip = parse_ip(ip_addr)
		if check_ip(resulting_ip):
			return resulting_ip
	return "0"

# ==================================================


func _ready():
	MusTheme.stop()
	var user_name = prepare_user_name()
	var user_ip = prepare_user_ip()
	if check_ip(user_ip):
		prepare_user_region(user_ip)

	var threaties = Dialogic.start("YOUR_LOCATION")
	Dialogic.VAR.user_name = user_name
	Dialogic.VAR.user_ip = user_ip if check_ip(user_ip) else "0"
	add_child(threaties)
	
	# Для дебага
	Dialogic.timeline_ended.connect(_on_dialogic_event)
	#var dialog = Dialogic.start("YOUR_LOCATION")
	#add_child(dialog)

	#await dialog.timeline_ended
func _on_dialogic_event():
	print('dialogic event caught')
	TeamStats.emit_signal("game_over")
	#emit_signal("attack_ended")


#	"HOW AM 1 SUPOSED TO [play nice]  WHEN [TOXiC]s LIKE YOU"
#	"SIT IN THEIR [vault]s"
#	"AND [COMMIT; ] [MASSIVE] GENOCIDE"
#	"YOU [--force] ME TO CHEAT"


func start_attack():
	print("и тут я начинаю шмалять")
