@tool
extends Node
class_name Hider3D

const GROUP_NAME = "@Hider3D"
const VISIBILITY_END_META : StringName = "PreviousVisibilityEndRange"

## Hide sibling nodes when not looking at them
@export var enabled := false
var hidden := false

## Hider behavior on game start.
@export var on_game_start : GAMESTART = GAMESTART.CurrentState
enum GAMESTART {
	CurrentState, ## Leave nodes in their current state on game start
	ShowAll, ## Show all sibling nodes & their children on game start
	HideAll, ## Hide all sibling nodes & their children on game start
	}
## Hider's hiding behavior
@export var hide_mode : EDITOR = EDITOR.CompletelyInvisible
enum EDITOR {
	CompletelyInvisible, ## 3D nodes will be completely invisible
	}

## Do not hide node if it has this name
@export var except_name : Array[String]


func _ready() -> void:
	if Engine.is_editor_hint():
		add_to_group(GROUP_NAME)
		if enabled:
			hide_nodes()
			hidden = true
	else:
		match on_game_start:
			GAMESTART.CurrentState:
				pass # Nothing
			GAMESTART.ShowAll:
				show_nodes()
			GAMESTART.HideAll:
				hide_nodes()
		queue_free()


func hide_nodes():
	if not hidden: # Only run hides if not already hidden
		match hide_mode:
			EDITOR.CompletelyInvisible:
				_hide_nodes_invisible()
	hidden = true



func _hide_nodes_invisible():
	for sibling : Node in get_parent().get_children():
		if sibling.name in except_name:
			continue # Sibling is in the except list
		
		var instance : GeometryInstance3D = sibling as GeometryInstance3D
		if instance != null:
			instance.set_meta(VISIBILITY_END_META, float(instance.visibility_range_end))
			instance.visibility_range_end = 0.01


func show_nodes():
	hidden = false
	for sibling : Node in get_parent().get_children():
		var instance : GeometryInstance3D = sibling as GeometryInstance3D
		if instance != null:
			if instance.has_meta(VISIBILITY_END_META):
				instance.visibility_range_end = instance.get_meta(VISIBILITY_END_META)
				instance.remove_meta(VISIBILITY_END_META)
