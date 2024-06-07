@tool
extends EditorPlugin

const NODE_NAME = "Hider3D"
const GROUP_NAME = "@Hider3D"
const HIDER_PATH = "res://addons/hider_node/hider3d.gd"
const ICON_PATH = "res://addons/hider_node/hider.png"

var selection : EditorSelection = EditorInterface.get_selection()


func _enter_tree() -> void:
	add_custom_type(NODE_NAME, "Node", preload(HIDER_PATH), preload(ICON_PATH))
	selection.selection_changed.connect(_on_selection_changed)


func _exit_tree() -> void:
	remove_custom_type(NODE_NAME)


func _on_selection_changed() -> void:
	var root : Node = get_tree().edited_scene_root
	var selected_nodes : Array[Node] = selection.get_selected_nodes()
	
	var hiders : Array[Node] = get_tree().get_nodes_in_group(GROUP_NAME)
	if hiders.is_empty():
		return # No hiders in scene, no need to do checks.
	
	for selected_node : Node in selected_nodes:
		for hider : Hider3D in hiders:
			if not hider.enabled:
				continue # This hider is disabled. Skip.
			var hider_parent_path := str(root.get_path_to(hider.get_parent()))+"/"
			var selection_path := str(root.get_path_to(selected_node))
			if selection_path.begins_with(hider_parent_path):
				hider.show_nodes() # Show if [selected_node] is a sibling of [hider]
			else:
				hider.hide_nodes() # Hide if not
