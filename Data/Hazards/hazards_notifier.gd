extends Node
class_name HazardsNotifier

export (PackedScene) var hazard_notification
export (NodePath) var camera_path
onready var camera : Camera2D = get_node(camera_path) as Camera2D
onready var notif_sound_player = $notification_sound

func _ready() -> void:
	
	pass

func add_notification(hazard : Node2D):
	
	var hazard_notif : HazardNotification = hazard_notification.instance()
	add_child(hazard_notif)
	hazard_notif.set_hazard_reference(hazard, camera)
	
	check_sound_play()
	
	pass

func check_sound_play():
	
	if(not notif_sound_player.playing):
		notif_sound_player.play(0.0)
	
	pass
