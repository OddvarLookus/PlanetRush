extends Node
class_name HazardSpawner

export (PackedScene) var hazard_to_spawn
export (NodePath) var player_path
export (float, 256, 1000) var max_vertical_spawn_dist

onready var hazard_container : Node = $"hazards container" as Node
onready var player : Player = get_node(player_path) as Player
onready var spawn_timer : Timer = $"spawn timer" as Timer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player.connect("into_atmosphere", self, "start_spawning")
	
	pass # Replace with function body.

func start_spawning():
	spawn_timer.start()

func stop_spawning():
	
	pass

func spawn():
	randomize()
	var hazard : Hazard = hazard_to_spawn.instance()
	hazard.set_player_ref(player)
	hazard_container.add_child(hazard)
	hazard.start()
	#hazard.position = Vector2(rand_range(0,144), player.position.y - rand_range(260, max_vertical_spawn_dist))
	


func _on_spawn_timer_timeout() -> void:
	spawn()
	
	pass

