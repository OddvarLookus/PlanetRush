extends Node
class_name HazardSpawner

export (Array, PackedScene) var hazards_to_spawn
var hazards_instances = []
var spawn_timers = []

export (NodePath) var player_path
export (NodePath) var game_manager_path

#export (Array, Hazard) var hazards_to_spawn

onready var hazard_container : Node = $"hazards container" as Node
onready var game_manager : GameManager = get_node(game_manager_path) as GameManager
onready var player : Player = get_node(player_path) as Player


#onready var spawn_timer : Timer = $"spawn timer" as Timer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	initialize_hazards_instances()
	
	pass # Replace with function body.

func initialize_hazards_instances() -> void:
	
	for i in range(hazards_to_spawn.size()):
		
		hazards_instances.push_back(hazards_to_spawn[i].instance())
		var tim : Timer = Timer.new()
		tim.autostart = false
		tim.one_shot = false
		tim.wait_time = hazards_instances[i].get_time_between_spawn()
		add_child(tim)
		spawn_timers.push_back(tim)
		tim.connect("timeout", self, "spawn", [i])
		
	

func start_spawning():
	
	pass

func stop_spawning():
	
	pass

func spawn(idx : int):
	randomize()
	var hazard : Hazard = hazards_to_spawn[idx].instance()
	hazard.set_player_ref(player)
	hazard_container.add_child(hazard)
	hazard.start()
	
	spawn_timers[idx].start(hazards_instances[idx].get_time_between_spawn())
	

func check_timers():
	#this checks every spawn timer, to see if objects should be spawned or not
	for i in range(hazards_instances.size()):
		
		var player_height : int = game_manager.get_score()
		
		#check if the player is in between the correct heights to spawn this object
		if(player_height >= hazards_instances[i].start_spawn_height and player_height <= hazards_instances[i].end_spawn_height):
			if(spawn_timers[i].is_stopped()):
				spawn_timers[i].start(hazards_instances[i].get_time_between_spawn())
				pass
			pass
		else:#height is incorrect
			if(not spawn_timers[i].is_stopped()):
				spawn_timers[i].stop()
		
		pass
	pass


