extends ParallaxBackground


export (PackedScene) var cloudsBG
export (Array, Texture) var noise_textures
export (Shader) var cloudsShader

export (int) var num_clouds_BGFW
export (int) var num_clouds_BGB

export (Color) var clouds_BGFW_minCol
export (Color) var clouds_BGFW_maxCol

export (float) var clouds_BGFW_minH
export (float) var clouds_BGFW_maxH


export (Color) var clouds_BGB_minCol
export (Color) var clouds_BGB_maxCol

export (float) var clouds_BGB_minH
export (float) var clouds_BGB_maxH

func _ready() -> void:
	
	spawn_clouds()
	
	pass

func spawn_clouds() -> void:
	
	var curHeight : float = 0.0
	#spawn the clouds in the foreground
	for i in range (0, num_clouds_BGFW, 1):
		randomize()
		curHeight -= rand_range(clouds_BGFW_minH, clouds_BGFW_maxH)
		var cloudBG : ParallaxLayer = cloudsBG.instance()
		add_child(cloudBG)
		cloudBG.motion_scale = Vector2(1.0, 0.2)
		var cloudSprite : Sprite = cloudBG.get_child(0)
		cloudSprite.global_position.y = curHeight
		
		cloudSprite.material = ShaderMaterial.new()
		(cloudSprite.material as ShaderMaterial).shader = cloudsShader
		
		var cloudMat : ShaderMaterial = cloudSprite.material
		cloudMat.set_shader_param("noisetex", noise_textures[rand_range(0, noise_textures.size())]) 
		cloudMat.set_shader_param("cutAlphaHeight", rand_range(0.165, 0.212))
		cloudMat.set_shader_param("maxAlpha", rand_range(0.588, 0.655))
		cloudMat.set_shader_param("cutAlphaStrength", rand_range(1.98, 2.449))
		cloudMat.set_shader_param("AlphaCenterMultiplier", rand_range(2.666, 3.122))
		cloudMat.set_shader_param("scale", rand_range(1.58, 2.54))
		
		var dir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("direction", dir)
		cloudMat.set_shader_param("speed", rand_range(0.03, 0.05))
		
		var ocDir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("octaveDirection", ocDir)
		cloudMat.set_shader_param("octaveSpeed", rand_range(0.06, 0.11))
		cloudMat.set_shader_param("octaveScale", rand_range(2.9, 4.22))
		
		cloudMat.set_shader_param("latSpeed", rand_range(0.025, 0.034))
		cloudMat.set_shader_param("shapeVal", rand_range(1.03, 1.3))
		
		cloudMat.set_shader_param("octaveContribution", rand_range(0.33, 0.45))
		cloudMat.set_shader_param("color", lerp(clouds_BGFW_minCol, clouds_BGFW_maxCol, rand_range(0.0, 1.0)))
		
		pass
	
	
	
	
	var curHeight_0 : float = 0.0
	#spawn the clouds in the foreground
	for i in range (0, num_clouds_BGB, 1):
		randomize()
		curHeight_0 -= rand_range(clouds_BGB_minH, clouds_BGB_maxH)
		var cloudBG : ParallaxLayer = cloudsBG.instance()
		add_child(cloudBG)
		cloudBG.motion_scale = Vector2(1.0, 0.12)
		var cloudSprite : Sprite = cloudBG.get_child(0)
		cloudSprite.z_index -= 1
		cloudSprite.global_position.y = curHeight_0
		
		cloudSprite.material = ShaderMaterial.new()
		(cloudSprite.material as ShaderMaterial).shader = cloudsShader
		
		var cloudMat : ShaderMaterial = cloudSprite.material
		cloudMat.set_shader_param("noisetex", noise_textures[rand_range(0, noise_textures.size())]) 
		cloudMat.set_shader_param("cutAlphaHeight", rand_range(0.165, 0.212))
		cloudMat.set_shader_param("maxAlpha", rand_range(0.588, 0.655))
		cloudMat.set_shader_param("cutAlphaStrength", rand_range(1.98, 2.449))
		cloudMat.set_shader_param("AlphaCenterMultiplier", rand_range(2.666, 3.122))
		cloudMat.set_shader_param("scale", rand_range(3.5, 4.2))
		
		var dir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("direction", dir)
		cloudMat.set_shader_param("speed", rand_range(0.02, 0.03))
		
		var ocDir : Vector2 = Vector2(1.0, 0.0).rotated(rand_range(0.0, 2.0 * PI))
		cloudMat.set_shader_param("octaveDirection", ocDir)
		cloudMat.set_shader_param("octaveSpeed", rand_range(0.01, 0.023))
		cloudMat.set_shader_param("octaveScale", rand_range(5.4, 6.72))
		
		cloudMat.set_shader_param("latSpeed", rand_range(0.01, 0.022))
		cloudMat.set_shader_param("shapeVal", rand_range(1.2, 1.45))
		
		cloudMat.set_shader_param("octaveContribution", rand_range(0.33, 0.45))
		cloudMat.set_shader_param("color", lerp(clouds_BGB_minCol, clouds_BGB_maxCol, rand_range(0.0, 1.0)))
		
		pass
	
	pass

