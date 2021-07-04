extends RigidBody2D
class_name Hazard

export (bool) var shatter_on_impact
export (int, 1, 10) var number_of_fragments
export (PackedScene) var shatter_fragment
export (float, 0, 1000) var speed_for_shatter

export(int) var damage

enum FadeTypes {TIME=0, DISTANCE=1}
export(FadeTypes) var fade_type
export(float, 0.1, 100) var time_before_fade
export(float, 0.001, 5) var fade_time

var player : Player
var prev_velocity : Vector2

func _ready() -> void:
	self.connect("body_entered", self, "on_rb_collision")
	
	if(fade_type == FadeTypes.TIME):
		
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.wait_time = time_before_fade
		timer.start()
		timer.connect("timeout", self, "fade")
		
	
	pass

func _physics_process(delta: float) -> void:
	prev_velocity = linear_velocity


func set_player_ref(plr : Player):
	if(fade_type == FadeTypes.DISTANCE):
		player = plr
		var destroy_timer : Timer = Timer.new()
		add_child(destroy_timer)
		destroy_timer.wait_time = time_before_fade
		destroy_timer.connect("timeout", self, "fade")
		destroy_timer.autostart = true
		
	pass


func shatter():
	randomize()
	for i in range(number_of_fragments + rand_range(0,3)):
		var fragment : RigidBody2D = shatter_fragment.instance()
		call_deferred("add_child_to_parent", get_parent(), fragment)
		
		fragment.global_position = global_position + Vector2(rand_range(-15,15), rand_range(-15,15))
		fragment.apply_central_impulse(Vector2(rand_range(-100,100), rand_range(-250,-100)))
		queue_free()
		
	
	pass

func fade():
	
	if(fade_type == FadeTypes.TIME):
		var tw : Tween = Tween.new()
		add_child(tw)
		var endcol:Color = Color(modulate.r, modulate.g, modulate.b, 0)
		tw.interpolate_property(self, 'modulate', modulate, endcol, fade_time,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tw.connect("tween_completed", self, "destroy")
		tw.start()
	elif(fade_type == FadeTypes.DISTANCE):
		if(abs(global_position.y - player.global_position.y) > 600):
			var tw : Tween = Tween.new()
			add_child(tw)
			var endcol:Color = Color(modulate.r, modulate.g, modulate.b, 0)
			tw.interpolate_property(self, 'modulate', modulate, endcol, fade_time,Tween.TRANS_CUBIC,Tween.EASE_IN)
			tw.connect("tween_completed", self, "destroy")
			tw.start()
		
	


func destroy(object : Object, key : NodePath) -> void:
	queue_free()

func add_child_to_parent(parent_node : Node, node_to_add : Node):
	parent_node.add_child(node_to_add)
	pass

func on_rb_collision(body : Node):
	
	if(shatter_on_impact):
		if(body is StaticBody2D):
			if(prev_velocity.length() >= speed_for_shatter):
				shatter()
		elif(body is RigidBody2D):
			if(body.is_in_group("player")):
					var plr : Player = body
					var relative_speed : float = (prev_velocity - plr.prev_velocity).length()
					if(relative_speed >= speed_for_shatter):
						plr.take_damage(damage)
						shatter()
			else:
				var rb : RigidBody2D = body
				var relative_speed : float = (prev_velocity - rb.linear_velocity).length()
				if(relative_speed >= speed_for_shatter):
					shatter()
				
	pass
