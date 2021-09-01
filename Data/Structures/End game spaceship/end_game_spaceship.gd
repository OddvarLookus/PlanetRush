extends StaticBody2D

export (NodePath) var end_game_detect_area_path
onready var end_game_detect_area : Area2D = get_node(end_game_detect_area_path) as Area2D
onready var spaceship_animation : AnimationPlayer = $EndGameSpaceshipAnim as AnimationPlayer



var player : Player = null
var player_landed : bool = false

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

export(float) var landing_time
var current_landing_time : float = 0.0

func evaluate_player_landing(delta : float) -> void:
	
	if(player != null and not player_landed):
		#conditions for player having landed. keep conditions for some time and the landing will be successful
		if(abs(player.linear_velocity.length()) < 0.5):
			if(abs(player.rotation_degrees) < 0.5):
				
				current_landing_time += delta
				if(current_landing_time >= landing_time):
					#landing is successful
					player_landed = true
					player.controls_enabled = false
					
					
					spaceship_animation.play("BringShipUp")
					
					print("landing successful")
				
				pass
			else:
				current_landing_time = 0.0
			
		else:
			current_landing_time = 0.0
		
	else:
		current_landing_time = 0.0
	
	pass

func _process(delta: float) -> void:
	evaluate_player_landing(delta)
	
	pass
