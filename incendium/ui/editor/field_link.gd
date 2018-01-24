extends Node

# Includes
var Field = preload("res://ui/editor/field.gd")

# Exposed
export(NodePath) var fields_root
export(String) var field_name 

# Fields
var field_ref

func _ready():

	# Find field by name
	field_ref = search_children(get_node(fields_root))

func search_children(node):
	# Is this node what we're looking for?
	if node extends Field and node.field_name == field_name:
		return node
	# Otherwise look though children
	for c in node.get_children():
		var found = search_children(c)
		if found != null:
			return found
	
	return null
	
func get_field():
	return field_ref