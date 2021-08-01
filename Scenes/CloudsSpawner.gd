extends ParallaxBackground


export (PackedScene) var cloudsBG
export (Array, Texture) var noise_textures

export (int) var num_clouds_BGFW
export (int) var num_clouds_BGB

func _ready() -> void:
	
	spawn_clouds()
	
	pass

func spawn_clouds() -> void:
	
	#spawn the clouds in the foreground
	for i in range (0, num_clouds_BGFW, 1):
		randomize()
		var cloudBG : ParallaxLayer = cloudsBG.instance()
		add_child(cloudBG)
		var cloudSprite : Sprite = cloudBG.get_child(0)
		
		cloudSprite.texture = noise_textures[rand_range(0, noise_textures.size())]
		
		var cloudMat : ShaderMaterial = cloudSprite.material
		cloudMat.set_shader_param("cutAlphaHeight", rand_range(0.165, 0.212))
		cloudMat.set_shader_param("maxAlpha", rand_range(0.588, 0.655))
		cloudMat.set_shader_param("cutAlphaStrength", rand_range(1.98, 2.449))
		cloudMat.set_shader_param("alphaCenterMultiplier", rand_range(1.996, 2.122))
		cloudMat.set_shader_param("scale", rand_range(1.58, 2.54))
		
		var dir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("direction", dir)
		cloudMat.set_shader_param("speed", rand_range(0.03, 0.05))
		
		var ocDir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("octaveDirection", ocDir)
		cloudMat.set_shader_param("octaveSpeed", rand_range(0.06, 0.11))
		cloudMat.set_shader_param("octaveScale", rand_range(2.9, 4.22))
		
		cloudMat.set_shader_param("octaveContribution", rand_range(0.33, 0.45))
		
		
		pass
	
	pass

