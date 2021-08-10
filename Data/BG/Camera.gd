extends Camera2D


export (NodePath) var player_path;
onready var player : Player = get_node(player_path)

export (NodePath) var game_manager_path
onready var game_manager : GameManager = get_node(game_manager_path) as GameManager

func _ready():
	
	pass

func _process(delta):
	
	global_position = player.global_position
	global_position = Vector2(144/2 - 1, player.global_position.y)
	
	#global_position.y = min(282/2 - 1, global_position.y)
	global_position.y = clamp(global_position.y, -game_manager.final_height - 176 , 282/2 - 1)
	global_position.y = floor(global_position.y)
	
	pass
