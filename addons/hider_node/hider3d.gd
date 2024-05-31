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
			var hider_path := str(root.get_path_to(hider.get_parent()))+"/"
			var selection_path := str(root.get_path_to(selected_node))
			if hider_path in selection_path:
				print("show")
				hider # Show nodes if selection is inside
	#for node : Node in selected_nodes:
		#for hider : Hider3D in hiders:
			#if not hider.enabled:
				#continue
			#if (str(root.get_path_to(hider.get_parent()))+"/") in 
				#(str(root.get_path_to(node))+"/"):
				# Enable hider if 
				#enabled_hiders.append(hider)
				#hiders.erase(hider)
	#for hider in hiders:
		#if not hider.active:
			#continue
		#hider.hide_nodes()
		#hider.active = false
#
	#for hider in enabled_hiders:
		#hider.show_nodes()
		#hider.active = true
