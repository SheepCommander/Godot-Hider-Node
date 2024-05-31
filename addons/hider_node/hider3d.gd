@tool
extends Node
class_name Hider3D

const GROUP_NAME = "@Hider3D"

@export var enabled := false

enum GAMESTART {CurrentState, ShowAll, HideAll}
enum EDITOR {WireFrame, CompletelyInvisible}
## CurrentState: Leave nodes in their current state on game start
## ShowAll: Show all sibling nodes & their children on game start
## HideAll: Hide all sibling nodes & their children on game start
@export var on_game_start : GAMESTART = GAMESTART.CurrentState
## WireFrame: 3D nodes still show a wireframe
## CompletelyInvisible: 3D nodes will be completely invisible
@export var hide_mode : EDITOR = EDITOR.WireFrame

## Do not hide node if it has this name
@export var except_list_names : Array[String]


var hiding := false

func _ready() -> void:
	if Engine.is_editor_hint():
		add_to_group(GROUP_NAME)
		hiding = true
		_hide_nodes()
	else:
		match on_game_start:
			GAMESTART.CurrentState:
				pass # Nothing
			GAMESTART.ShowAll:
				_show_nodes()
			GAMESTART.HideAll:
				_hide_nodes()
		queue_free()


func _process(delta: float) -> void:
	pass


func _hide_nodes():
	match hide_mode:
		EDITOR.WireFrame:
			_hide_nodes_wireframe()
		EDITOR.CompletelyInvisible:
			_hide_nodes_invisible()


func _hide_nodes_wireframe():
	pass


func _hide_nodes_invisible():
	pass


func _show_nodes():
	pass
