extends RigidBody2D
class_name Player

export (float, 0, 1000) var acceleration
export (float, 0, 4000) var rotation_speed

export (int) var max_health : int
var health : int 
export (float) var max_speed

export (NodePath) var game_manager_path
onready var game_manager : GameManager = get_node(game_manager_path) as GameManager

onready var booster_particles : CPUParticles2D = $ReactorParticles as CPUParticles2D
onready var ground_smoke_particles : CPUParticles2D = $GroundSmokeParticles as CPUParticles2D
onready var smoke_raycast : RayCast2D = $SmokeRaycast as RayCast2D
onready var player_hurt_anim_player : AnimationPlayer = $PlayerHurtAnim as AnimationPlayer

var prev_velocity : Vector2
var controls_enabled : bool = true

signal damaged(current_health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	
	pass


func _process(delta: float) -> void:
	
	
	pass


func _physics_process(delta: float) -> void:
	
	if(controls_enabled):
		take_input(delta)
	
	prev_velocity = linear_velocity
	pass


func take_input(delta : float) -> void:
	
	if(Input.is_action_pressed("left")):
		
		apply_torque_impulse(-rotation_speed * delta)
		
		pass
	
	if(Input.is_action_pressed("right")):
		
		apply_torque_impulse(rotation_speed * delta)
		
		pass
	
	if(Input.is_action_pressed("accelerate")):
		
		apply_central_impulse((Vector2(0,-1) * acceleration).rotated(rotation) * delta) 
		
		if(not booster_particles.emitting):
			booster_particles.emitting = true
		
		if(smoke_raycast.is_colliding()):
			ground_smoke_particles.global_position = smoke_raycast.get_collision_point()
			
			if(ground_smoke_particles.emitting == false):
				ground_smoke_particles.emitting = true
		else:
			if(ground_smoke_particles.emitting == true):
				ground_smoke_particles.emitting = false
		
	else:
		if(booster_particles.emitting):
			booster_particles.emitting = false
		if(ground_smoke_particles.emitting):
			ground_smoke_particles.emitting = false
		pass
	



func take_damage( dmg : int) -> void:
	player_hurt_anim_player.play("PlayerHurt")
	health -= dmg
	health = clamp(health, 0, max_health)
	emit_signal("damaged", health)
	if(health <= 0):
		detonate()
	pass 

func detonate() -> void:
	
	get_tree().reload_current_scene()
	
	pass

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	wrap(state)
	clamp_velocity(state)
	pass

func wrap(state: Physics2DDirectBodyState) -> void:
	
	if(position.x > 146):
		state.transform = Transform2D(rotation, Vector2(0, position.y))
	elif(position.x < -2):
		state.transform = Transform2D(rotation, Vector2(144, position.y))
	
	pass

func clamp_velocity(state: Physics2DDirectBodyState):
	if(state.linear_velocity.y < -max_speed or abs(state.linear_velocity.x) > max_speed):
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	elif(state.linear_velocity.y > max_speed * 2):
		state.linear_velocity = state.linear_velocity.normalized() * max_speed * 2
	pass
