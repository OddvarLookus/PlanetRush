extends RigidBody2D
class_name Hazard

export (PackedScene) var player_damaged_particles

export (bool) var shatter_on_impact
export (int, 1, 10) var number_of_fragments
export (PackedScene) var shatter_fragment
export (float, 0, 1000) var speed_for_shatter

export(int) var damage

enum FadeTypes {TIME=0, DISTANCE=1}
export(FadeTypes) var fade_type
export(float, 0.1, 100) var time_before_fade
export(float, 0.001, 5) var fade_time

#VARIABLES FOR SPAWN------------------------------------------------------------
enum SpawnModes{LATERAL = 0, TOP = 1, BOTTOM = 2, OMNIDIRECTIONAL = 3}
export (SpawnModes) var spawn_mode
export (float) var min_height
export (float) var max_height
export (float) var min_distance
export (float) var max_distance

export (float) var min_time_between_spawn
export (float) var max_time_between_spawn

func get_time_between_spawn() -> float:
	randomize()
	return rand_range(min_time_between_spawn, max_time_between_spawn)
#-------------------------------------------------------------------------------
export (bool) var rotation_follows_velocity


var player : Player
var prev_velocity : Vector2
var body_state : Physics2DDirectBodyState

export (int) var start_spawn_height : int
export (int) var end_spawn_height : int


func _ready() -> void:
	_custom_ready()
	
	pass

func _custom_ready():
	self.connect("body_entered", self, "on_rb_collision")
	
	if(fade_type == FadeTypes.TIME):
		
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.wait_time = time_before_fade
		timer.start()
		timer.connect("timeout", self, "fade")
		
	

func _physics_process(delta: float) -> void:
	_custom_physics_process(delta)

func _custom_physics_process(delta: float) -> void:
	prev_velocity = linear_velocity

func set_player_ref(plr : Player):
	player = plr
	if(fade_type == FadeTypes.DISTANCE):
		var destroy_timer : Timer = Timer.new()
		add_child(destroy_timer)
		destroy_timer.wait_time = time_before_fade
		destroy_timer.connect("timeout", self, "fade")
		destroy_timer.autostart = true
		
	pass

func start():
	randomize()
	match spawn_mode:
		SpawnModes.LATERAL:
			var spawn_left : bool = rand_range(0.0,1.0) > 0.5
			
			var pos_x : float = rand_range(min_distance, max_distance)
			var pos_y : float = rand_range(player.global_position.y - min_height, player.global_position.y - max_height)
			
			if(spawn_left):
				global_position = Vector2(72.0 - pos_x, pos_y)
				pass
			elif(!spawn_left):
				global_position = Vector2(72.0 + pos_x, pos_y)
				pass
			
			pass
		SpawnModes.TOP:
			var pos_x : float = rand_range(0.0, 144.0)
			var pos_y : float = rand_range(player.global_position.y - min_height, player.global_position.y - max_height)
			global_position = Vector2(pos_x, pos_y)
			
			pass
		SpawnModes.BOTTOM:
			var pos_x : float = rand_range(0.0, 144.0)
			var pos_y : float = rand_range(player.global_position.y + max_height, player.global_position.y + min_height)
			global_position = Vector2(pos_x, pos_y)
			
			pass
		SpawnModes.OMNIDIRECTIONAL:
			var dist : float = rand_range(min_distance, max_distance)
			var base_vec : Vector2 = Vector2(rand_range(-1,1), rand_range(-1,1))
			base_vec = base_vec.normalized()
			base_vec *= dist
			global_position = player.global_position + base_vec
			
			pass
	
	pass

#generic implementation for shattering. can be overridden
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
						if (body_state.get_contact_count() >= 1):
							var impact_pos : Vector2 = body_state.get_contact_collider_position(0)
							var pDmg : CPUParticles2D = player_damaged_particles.instance()
							get_parent().add_child(pDmg)
							pDmg.global_position = impact_pos
							
							var normal : Vector2 = body_state.get_contact_local_normal(0)
							var angle : float = normal.angle()
							pDmg.rotation = angle
							
							pDmg.emitting = true
							
							pass
			else:
				var rb : RigidBody2D = body
				var relative_speed : float = (prev_velocity - rb.linear_velocity).length()
				if(relative_speed >= speed_for_shatter):
					shatter()
				
	else:#not shatter on impact
		
		if(body is RigidBody2D):
			if(body.is_in_group("player")):
				var plr : Player = body
				plr.take_damage(damage)
			pass
		
		pass
	pass


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	body_state = state
	rotate_to_velocity(state)
	
	pass

#basic implementation for rotating to velocity. code can be changed by override
func rotate_to_velocity(state: Physics2DDirectBodyState):
	if(rotation_follows_velocity):
		var rot := state.linear_velocity.angle()
		state.transform = Transform2D(rot, global_position)
	
	pass
