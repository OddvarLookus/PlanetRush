extends Node
class_name GameManager

export (NodePath) var player_path
onready var player = get_node(player_path)

export (float) var final_height

var start_player_pos : Vector2

var game_time_started : bool = false
var game_time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.window_maximized = true
	
	start_player_pos = player.position
	pass

func _process(delta: float) -> void:
	calculate_game_time(delta)
	
	pass

func calculate_game_time(delta : float) -> void:
	
	if(get_player_height() > 0.0 and !game_time_started):
		game_time_started = true
	
	if(game_time_started):
		game_time += delta
	

func get_formatted_time() -> String:
	
	var secs : float = float(int(floor(game_time)) % 60)
	var mins : float = game_time / 60.0
	secs = floor(secs)
	mins = floor(mins)
	
	var secs_str : String = str(secs)
	var mins_str : String = str(mins)
	if(secs <= 9.0):
		secs_str = "0" + secs_str
	if(mins <= 9.0):
		mins_str = "0" + mins_str
	
	var formtime : String = mins_str + " : " + secs_str
	return formtime
	pass

func get_score() -> int:
	var score : int = int(player.position.y - start_player_pos.y)
	score = min(0, score)
	score = -score
	score /= 10
	return score
	

func get_player_height() -> float:
	var p_height : float = clamp(-player.global_position.y, 0.0, final_height)
	return p_height

func get_completion_rate() -> float:
	return get_player_height() / final_height
	pass
