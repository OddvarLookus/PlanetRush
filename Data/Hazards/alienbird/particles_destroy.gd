extends CPUParticles2D



func _ready() -> void:
	emitting = true
	
	pass

func _process(delta: float) -> void:
	
	check_emitting()
	
	pass

func check_emitting():
	
	if(not emitting):
		var destroy_timer : Timer = Timer.new()
		destroy_timer.wait_time = lifetime + 1.0
		add_child(destroy_timer)
		destroy_timer.start()
		destroy_timer.connect("timeout", self, "on_destroy_timer_timeout")
	
	pass


func on_destroy_timer_timeout():
	queue_free()
	pass
