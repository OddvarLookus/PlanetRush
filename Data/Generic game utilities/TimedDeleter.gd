extends Node


export (float, 0.01, 10.0) var time_before_deletion
export (NodePath) var node_to_delete_path

var node_to_delete : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if(node_to_delete_path == null):
		node_to_delete = self
	else:
		node_to_delete = get_node(node_to_delete_path)
	
	
	var t : Timer = Timer.new()
	add_child(t)
	t.wait_time = time_before_deletion
	t.connect("timeout", self, "delete_self")
	t.start()
	
	pass

func delete_self():
	queue_free()
	


