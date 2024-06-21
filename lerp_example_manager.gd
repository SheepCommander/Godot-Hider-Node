@tool
extends Node


@export_range(0.5,6,0.5) var rate: float = .5 : set = _set_rate
var _rate : float  #exp2(rate)
@export var restart := false

@onready var start: Sprite2D = %Start
@onready var target: Sprite2D = $Target


func _set_rate(x):
	rate = x
	_rate = exp(rate * log(2))
	print("human-readable rate %s == logarithmic actual _rate %s" % [rate, _rate])
	for lerp in get_tree().get_nodes_in_group("@lerp"):
		lerp._rate = _rate
	restart = true


@onready var _prev_target_pos := target.position
func _process(delta: float) -> void:
	if target.position != _prev_target_pos:
		_prev_target_pos = target.position
		for lerp in get_tree().get_nodes_in_group("@lerp"):
			lerp.process_mode = Node.PROCESS_MODE_INHERIT
	
	if restart:
		restart = false
		for node in get_tree().get_nodes_in_group("@lerp"):
			node.position = start.position
			node.total_t = 0
			node.t = 0
			node.half_reached = false
			node.process_mode = Node.PROCESS_MODE_INHERIT
