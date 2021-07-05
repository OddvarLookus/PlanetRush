extends Camera2D


export (NodePath) var player_path;
onready var player : Player = get_node(player_path)

func _ready():
	
	pass

func _process(delta):
	
	global_position = player.global_position
	global_position = Vector2(144/2 - 1, player.global_position.y)
	
	global_position.y = min(256/2 - 1, global_position.y)
	
	pass
