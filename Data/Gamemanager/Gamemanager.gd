extends Node
class_name GameManager

export (NodePath) var player_path
onready var player = get_node(player_path)


var start_player_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.window_maximized = true
	
	start_player_pos = player.position
	pass

func _process(delta: float) -> void:
	
	
	pass


func get_score() -> int:
	var score : int = int(player.position.y - start_player_pos.y)
	score = min(0, score)
	score = -score
	score /= 10
	return score
	
