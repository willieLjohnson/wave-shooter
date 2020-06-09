extends Node2D

func _ready() -> void:
	Global.node_creation_parent = self
	
func _exit_tree() -> void:
	Global.node_creation_parent = null
