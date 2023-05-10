extends Line2D

var body

func _ready():
	print('trace added')


func _process(delta):
	add_point(body.global_position)
