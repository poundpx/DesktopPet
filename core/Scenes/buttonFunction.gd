extends Node2D

#toggle option menu
func _toggleOption():
	self.visible = !self.visible
	
func _on_area_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
