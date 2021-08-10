extends StaticBody2D

export (NodePath) var end_game_detect_area_path
onready var end_game_detect_area : Area2D = get_node(end_game_detect_area_path) as Area2D


var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_game_detect_area.connect("body_entered", self, "on_end_game_area_entered")
	end_game_detect_area.connect("body_exited", self, "on_end_game_area_exited")
	
	pass # Replace with function body.

func on_end_game_area_entered(body : Node):
	if(body.is_in_group("player")):
		player = body as Player
	
	pass

func on_end_game_area_exited(body : Node):
	if(body.is_in_group("player")):
		player = null
	
	pass

func evaluate_player_landing() -> bool:
	
	
	return false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
