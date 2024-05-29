@tool
extends EditorPlugin

var selection : EditorSelection = get_editor_interface().get_selection()
const NODE_NAME = "Hider3D"
const HIDER_PATH = "res://addons/hider_node/hider3d.gd"
const ICON_PATH = "res://addons/hider_node/hider.png"

func _enter_tree() -> void:
	add_custom_type(NODE_NAME, "Node", preload(HIDER_PATH), preload(ICON_PATH))
	selection.selection_changed.connect(_on_selection_changed)


func _exit_tree() -> void:
	remove_custom_type(NODE_NAME)


func _on_selection_changed() -> void:
	var selected_nodes : Array[Node] = selection.get_selected_nodes()
	var hiders : Array[Node] = get_tree().get_nodes_in_group(NODE_NAME)
	var enabled_hiders : Array[Node]
	var current_scene : Node = get_tree().edited_scene_root
	
	for node : Node in selected_nodes:
		for hider : Hider3D in hiders:
			if not hider.enabled:
				continue
			if (str(current_scene.get_path_to(hider.get_parent()))+"/") in (str(current_scene.get_path_to(node))+"/"):
				enabled_hiders.append(hider)
				hiders.erase(hider)
	
	for hider in hiders:
		if not hider.active:
			continue
		hider.hide_nodes()
		hider.active = false

	for hider in enabled_hiders:
		hider.show_nodes()
		hider.active = true
