extends RigidBody2D
class_name Player

export (float, 0, 1000) var acceleration
export (float, 0, 4000) var rotation_speed

export (int) var health : int
export (float) var max_speed

export (NodePath) var game_manager_path
onready var game_manager : GameManager = get_node(game_manager_path) as GameManager

onready var booster_particles : CPUParticles2D = $CPUParticles2D as CPUParticles2D

var in_atmosphere : bool = false
var prev_velocity : Vector2
signal into_atmosphere


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	check_if_in_atmosphere()
	
	pass

func check_if_in_atmosphere():
	if(not in_atmosphere and game_manager.get_score() > 20):
		in_atmosphere = true
		emit_signal("into_atmosphere")
		print("signal emitted")
	

func _physics_process(delta: float) -> void:
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
		
	else:
		if(booster_particles.emitting):
			booster_particles.emitting = false
		
		pass
	

func take_damage( dmg : int) -> void:
	health -= dmg
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
