extends Sprite
class_name HazardNotification

onready var anim_player = $AnimationPlayer

export (int) var margin

var hazard : Node2D
var camera : Camera2D
onready var viewport_size : Vector2 = get_viewport_rect().size

var can_vanish : bool = true

var last_pos : Vector2

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	clamp_notification_position()
	pass

func set_hazard_reference(_hazard : Node2D, _camera : Camera2D):
	hazard = _hazard
	camera = _camera
	pass

func clamp_notification_position():
	
	var hz_pos : Vector2
	if(is_instance_valid(hazard)):
		hz_pos = hazard.global_position
		last_pos = hz_pos
	
	
	if(is_in_viewport() and can_vanish):
		anim_player.play("hazard_notification_fade_anim")
		can_vanish = false
		pass
	elif(not is_in_viewport()):
		var cam_pos = camera.get_camera_position()
		
		var pos_x : float = clamp(last_pos.x, cam_pos.x - viewport_size.x / 2.0 + margin, cam_pos.x + viewport_size.x / 2.0 - margin)
		var pos_y : float = clamp(last_pos.y, cam_pos.y + viewport_size.y / 2.0 + margin, cam_pos.x - viewport_size.y / 2.0 - margin)
		
		global_position = Vector2(pos_x, pos_y)
		
		pass
	
	pass

func is_in_viewport() -> bool:
	
	if(is_instance_valid(hazard)):
		
		var cam_pos : Vector2 = camera.get_camera_position()
		var is_in_x : bool = false
		var is_in_y : bool = false
		
		if(hazard.global_position.x > cam_pos.x - viewport_size.x / 2.0 and hazard.global_position.x < cam_pos.x + viewport_size.x / 2.0):
			is_in_x = true
		
		if(hazard.global_position.y < cam_pos.y + viewport_size.y / 2.0 and hazard.global_position.y > cam_pos.y - viewport_size.y / 2.0):
			is_in_y = true
		
		return (is_in_x and is_in_y)
	else:
		return false
		pass
	
	pass

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	
	if(anim_name == "hazard_notification_anim"):
		anim_player.play("hazard_notification_fade_anim")
		can_vanish = false
	elif(anim_name == "hazard_notification_fade_anim"):
		queue_free()
	
	pass


