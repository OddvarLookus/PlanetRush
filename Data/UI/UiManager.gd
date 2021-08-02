extends Control


export (PackedScene) var playerHealthNugget
export (NodePath) var playerHealthParentPath
onready var playerHealthParent : HBoxContainer = get_node(playerHealthParentPath) as HBoxContainer

export (Color) var healthNuggetCol
export (Color) var HealthNuggetDepletedCol

export (NodePath) var gameManagerPath
onready var gameManager : GameManager = get_node(gameManagerPath) as GameManager


func _ready() -> void:
	
	#wait for the next frame before starting the visuals
	yield(get_tree(), "idle_frame")
	start_health_visual()
	
	pass

func _process(delta: float) -> void:
	
	
	pass

func start_health_visual() -> void:
	
	var plr : Player = gameManager.player as Player
	var p_max_health : int = plr.max_health
	
	for i in range (0, p_max_health, 1):
		
		var h_nugget : TextureRect = playerHealthNugget.instance()
		playerHealthParent.add_child(h_nugget)
		h_nugget.self_modulate = healthNuggetCol
		
		
	
	plr.connect("damaged", self, "_on_player_damaged")
	
	pass

func _on_player_damaged(cur_player_health : int) -> void:
	
	for i in range (0, playerHealthParent.get_child_count(), 1):
		
		var h_nugget : TextureRect = playerHealthParent.get_child(i)
		
		if(i < cur_player_health):
			h_nugget.self_modulate = healthNuggetCol
		else:
			h_nugget.self_modulate = HealthNuggetDepletedCol
		
		pass
	
	pass
