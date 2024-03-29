extends Hazard
class_name AlienBird

export (float) var min_horizontal_speed
export (float) var max_horizontal_speed
export (float) var velocity_trajectory_error
export (float) var min_flap_power
export (float) var max_flap_power
export (float) var flap_interval

export (Texture) var bird_downward_tex

onready var bird_sprite := $Sprite
onready var anim := $AnimationPlayer

var flap_timer : Timer

func _custom_ready():
	._custom_ready()
	
	pass

func start():
	.start()
	randomize()
	
	if(spawn_mode == SpawnModes.LATERAL):
		#start the velocity of the bird
		var err_rad : float = deg2rad(rand_range(-velocity_trajectory_error, velocity_trajectory_error))
		var init_horizontal_speed : float = rand_range(min_horizontal_speed, max_horizontal_speed)
		var desired_vel : Vector2
		
		if(position.x < 72):
			desired_vel = Vector2(1,0) * init_horizontal_speed
			desired_vel = desired_vel.rotated(err_rad)
		elif(position.x >= 72):
			desired_vel = Vector2(-1,0) * init_horizontal_speed
			desired_vel = desired_vel.rotated(err_rad)
		
		apply_central_impulse(desired_vel)
		
		#initialize the flap timer
		flap_timer = Timer.new()
		add_child(flap_timer)
		flap_timer.one_shot = true
		flap_timer.wait_time = flap_interval
		flap_timer.start()
		
	if(spawn_mode == SpawnModes.TOP):
		
		bird_sprite.texture = bird_downward_tex
		
		var desired_vel : Vector2 = Vector2(rand_range(min_horizontal_speed, max_horizontal_speed), 0)
		if(rand_range(0.0, 1.0) >= 0.5):
			desired_vel *= -1
		
		apply_central_impulse(desired_vel)
		pass
	
	pass

func _custom_physics_process(delta : float) -> void:
	._custom_physics_process(delta)
	if(spawn_mode == SpawnModes.LATERAL):
		check_flap()
	

func check_flap():
	if(linear_velocity.y >= 0):
		if(flap_timer.time_left <= 0.0):
			flap()

func flap():
	randomize()
	flap_timer.start()
	anim.play("alienbird flap")
	
	if(abs(linear_velocity.x) > 40):#has velocity on x axis
		apply_central_impulse(Vector2(0, -1) * rand_range(min_flap_power, max_flap_power))
	else:#no velocity on x axis
		var frc : Vector2 = Vector2(rand_range(-1,1), rand_range(-1,0)).normalized()
		frc *= rand_range(min_flap_power, max_flap_power)
		apply_central_impulse(frc)
	

func rotate_to_velocity(state : Physics2DDirectBodyState):
	if(rotation_follows_velocity):
		
		if(spawn_mode == SpawnModes.LATERAL):
			
			if(abs(state.linear_velocity.x) > 6.0):
				
				if(state.linear_velocity.x >= 0):
					if(bird_sprite.flip_h):
						bird_sprite.flip_h = false
					
					var rot : float = state.linear_velocity.angle()
					var real_rot : float = lerp(rotation, rot, state.step)
					state.transform = Transform2D(rot, global_position)
					
				elif(state.linear_velocity.x < 0):
					if(!bird_sprite.flip_h):
						bird_sprite.flip_h = true
					
					var rot : float = state.linear_velocity.angle()
					rot -= PI
					var real_rot : float = lerp(rotation, rot, state.step)
					state.transform = Transform2D(rot, global_position)
					
				
			
		if(spawn_mode == SpawnModes.TOP):
			
			if(linear_velocity.x >= 0):
				if(bird_sprite.flip_h == true):
					bird_sprite.flip_h = false
			elif(linear_velocity.x < 0):
				if(bird_sprite.flip_h == false):
					bird_sprite.flip_h = true
			
			pass
		
	

func shatter():
	
	var feathers : CPUParticles2D = shatter_fragment.instance()
	get_parent().add_child(feathers)
	feathers.global_position = global_position
	queue_free()
	
	pass


