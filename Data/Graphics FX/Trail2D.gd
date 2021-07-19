extends Line2D

export (int) var max_points

var active : bool = false
var offset : Vector2
onready var parent : Node2D = get_parent() as Node2D

func _ready() -> void:
	offset = position
	pass


func _process(delta: float) -> void:
	
	draw_trail(delta)
	
	pass

func draw_trail(delta : float):
	
	global_position = Vector2.ZERO
	global_rotation = 0.0
	global_scale = Vector2.ONE
	
	add_point(parent.global_position + offset, 0)
	
	if(get_point_count() > max_points):
		
		remove_point(get_point_count() - 1)
		
	
	pass
