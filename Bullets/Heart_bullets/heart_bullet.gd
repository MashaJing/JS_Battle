extends Area2D

var trail
var speed = 0
var radius = 100


func _ready():
	trail = Line2D.new()
	trail.default_color = Color.FOREST_GREEN
	trail.width = 2
	trail.z_index = 0
	trail.add_point(position)
	get_parent().call_deferred("add_child", trail)
	start_move(2)

func get_child_heart():
	print(get_parent().get_children())
	var children = get_children()
	for child in children:
		if child.is_in_group('heart'):
			return child

func set_child_heart(child_heart):
	child_heart.add_to_group('heart')
	add_child(child_heart)
	child_heart.position = Vector2(radius, 0)

func start_move(speed):
	self.speed = speed

func glitch():
	pass
	# тут анимация глича

func _process(delta):
	rotation += speed * delta
	trail.add_point(position)

#func glitch():
	#add_child(Sprite.new()) ? или дублированием
#	print('GLITCH GLITCH')
