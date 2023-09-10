extends Node2D


# ============== region and country ==============
func prepare_user_region(user_ip):
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("http://demo.ip-api.com/json/" + user_ip)



func _on_request_completed(result, response_code, headers, body):
	var json = (JSON.parse(body.get_string_from_utf8())).result
	# TODO: обработать случаи, когда апишка не отдаёт эти поля
	Dialogic.set_variable('user_country', json['country'])
	Dialogic.set_variable('user_region', json['regionName'])
	
	
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
	ip_arr.invert()
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
	var exit_code = OS.execute("nslookup", ["myip.opendns.com.", "resolver1.opendns.com"], true, ip_addr)
	print(ip_addr)
	if exit_code == 0:
		ip_addr[0].find("IPv4")
		var resulting_ip = parse_ip(ip_addr)
		if check_ip(resulting_ip):
			return resulting_ip
	return "0"

# ==================================================


func _ready():
	var user_name = prepare_user_name()
	var user_ip = prepare_user_ip()
	if check_ip(user_ip):
		prepare_user_region(user_ip)

	var threaties = Dialogic.start("jevil_down")
	Dialogic.set_variable('user_name', user_name)
	Dialogic.set_variable('user_ip', user_ip if check_ip(user_ip) else "0")
	add_child(threaties)
	
	# Для дебага
	yield(threaties, 'dialogic_signal')
	var dialog = Dialogic.start("jevil_down_end")
	add_child(dialog)


#	"HOW AM 1 SUPOSED TO [play nice]  WHEN [TOXiC]s LIKE YOU"
#	"SIT IN THEIR [vault]s"
#	"AND [git commit] [MASSIVE] GENOCIDE"
#	"YOU [--force] ME TO CHEAT"


func start_attack():
	print("и тут я начинаю шмалять")
