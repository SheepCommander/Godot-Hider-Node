@tool
extends Node
class_name Hider

@export var enabled:bool = false : set = enable
var active:bool = false

enum GAMESTART {Default, HideAll, CurrentState}
@export var on_game_start:GAMESTART = GAMESTART.Default
enum EDITOR {Default, ShowAll}
@export var editor_behavior:EDITOR = EDITOR.Default

@export var except_list:Array[String] = []

@export var saved_states:Dictionary = {} # {node: visible:bool}


func _ready():
	if not Engine.is_editor_hint():
		match on_game_start:
			GAMESTART.Default: show_nodes()
			GAMESTART.HideAll: _hide_nodes()
			GAMESTART.CurrentState: pass
	else:
		active = false
		add_to_group("@Hider")
		_hide_nodes()
#		get_parent().child_entered_tree.connect(update_list)
#	 	get_parent().child_exiting_tree.connect(update_list)

func update_list(_node:Node=null, init:bool=false):
	if not get_parent(): return
	saved_states.clear()
	for node in get_parent().get_children():
		if node.name in except_list or not node.has_signal("visibility_changed"): continue
		if init: node.renamed.connect(update_list)
		else: saved_states[node.name] = node.visible

func show_nodes():
	if not enabled: return
	match editor_behavior:
		EDITOR.Default:
			for node in saved_states.keys(): get_parent().get_node(node).visible = saved_states[node]
		EDITOR.ShowAll:
			for node in saved_states.keys(): get_parent().get_node(node).visible = true

func hide_nodes():
	update_list()
	_hide_nodes()

func _hide_nodes():
	if not enabled: return
	for node in get_parent().get_children():
		if node.name in except_list or not node.has_signal("visibility_changed"): continue
		node.visible = false

func enable(value):
	enabled = value
	update_list()
	if not enabled:
		for node in saved_states.keys(): get_parent().get_node(node).visible = saved_states[node]

func is_node_visible(node:Node):
	return saved_states[node.name]

func is_node_path_visible(node:NodePath):
	return saved_states[get_node(node).name]

func is_node_name_visible(node:String):
	return saved_states[node]
