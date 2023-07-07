extends Line2D

export var upper_position = Vector2.ZERO
export var heart_position = Vector2.ZERO
export var lower_position = Vector2.ZERO
onready var graphic_path = $GraphicBullet
onready var graphic_line = $GraphicLine
onready var graphic_arrow = $GraphicBullet/PathFollow2D/GraphicArrow
onready var graphic_path_follow = $GraphicBullet/PathFollow2D

var speed = 500
var attack = false
var pts = PoolVector2Array()
var path_curve = Curve2D.new()


func _ready():
	for pt in [upper_position, heart_position, lower_position]:
		pts=add_point(pt)
		path_curve.add_point(pt)
	$TTL.start()

func _on_TTL_timeout():
	clear_points()
	graphic_path.set_curve(path_curve)
	graphic_arrow.visible = true
	attack = true

func _process(delta):
	if attack:
		graphic_path_follow.set_offset(graphic_path_follow.get_offset() + delta * speed)
		# + Vector2(...) - придаёт хаотичную искривлённость линии
		pts = graphic_line.add_point(graphic_path_follow.position + Vector2(randi() % 10 - 5, randi() % 5 - 5))
		# дошли до конца пути - стираем
		if 0.9 <= graphic_path_follow.unit_offset:
			clear_points()
			queue_free()
