extends Node
class_name HazardsNotifier

export (PackedScene) var hazard_notification
export (NodePath) var camera_path
onready var camera : Camera2D = get_node(camera_path) as Camera2D


func _ready() -> void:
	
	pass

func add_notification(hazard : Node2D):
	
	var hazard_notif : HazardNotification = hazard_notification.instance()
	add_child(hazard_notif)
	hazard_notif.set_hazard_reference(hazard, camera)
	
	pass

