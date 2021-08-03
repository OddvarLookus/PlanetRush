extends Control


export (PackedScene) var playerHealthNugget
export (NodePath) var playerHealthParentPath
onready var playerHealthParent : HBoxContainer = get_node(playerHealthParentPath) as HBoxContainer

export (NodePath) var levelProgressBarPath
onready var levelProgressBar : TextureProgress = get_node(levelProgressBarPath) as TextureProgress

export (NodePath) var timeLabelPath
onready var timeLabel : Label = get_node(timeLabelPath) as Label

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
	update_progression_bar()
	update_time_label()
	pass

func start_health_visual() -> void:
	
	var plr = gameManager.player
	var p_max_health : int = plr.max_health
	
	for i in range (0, p_max_health, 1):
		
		var h_nugget : TextureRect = playerHealthNugget.instance()
		playerHealthParent.add_child(h_nugget)
		h_nugget.self_modulate = healthNuggetCol
		
	
	plr.connect("damaged", self, "_on_player_damaged")
	
	pass

func update_time_label() -> void:
	
	timeLabel.text = gameManager.get_formatted_time()
	
	pass

func _on_player_damaged(cur_player_health : int) -> void:
	#change health value in the UI
	for i in range (0, playerHealthParent.get_child_count(), 1):
		
		var h_nugget : TextureRect = playerHealthParent.get_child(i)
		
		if(i < cur_player_health):
			h_nugget.self_modulate = healthNuggetCol
		else:
			h_nugget.self_modulate = HealthNuggetDepletedCol
		
		pass
	
	pass

func update_progression_bar() -> void:
	levelProgressBar.value = gameManager.get_completion_rate()
	pass
