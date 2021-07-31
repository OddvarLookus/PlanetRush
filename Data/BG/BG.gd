extends Sprite

export (NodePath) var camera_path
onready var camera : Camera2D = get_node(camera_path)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	(material as ShaderMaterial).set_shader_param("worldPos", camera.global_position)
	
	pass

