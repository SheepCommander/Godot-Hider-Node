@tool
extends Sprite2D

@onready var start: Sprite2D = $"../Start"
@onready var target: Sprite2D = $"../Target"

@export var fps: int
@onready var _rate : float = exp(0.5 * log(2)) #exp2(rate)

var t: float
var total_t: float


func _ready() -> void:
	position = start.position
	name = "lerp%s" % fps
	randomize()
	self_modulate = Color(randi_range(0,244),randi_range(0,244),randi_range(0,244))
	process_mode = Node.PROCESS_MODE_INHERIT
	add_to_group("@lerp")


func _process(delta: float) -> void:
	if fps == 0: _move(delta); return
	
	t += delta
	
	if t >= 1/fps:
		_move(t)
		t = 0


var half_reached := false
func _move(delta: float) -> void:
	position = lerp(position, target.position, 1 - exp(-_rate*delta * log(2)))
	total_t += delta
	
	if not half_reached and start.position.distance_to(position) >= \
				start.position.distance_to(target.position)/2:
		printt("halfway @ %s secs" % total_t)
		half_reached = true
	
	if position.is_equal_approx(target.position):
		printt("Rate: %s	approx target @ %ss	fps %s" % [get_parent().rate,total_t, fps])
		total_t = 0
		process_mode = Node.PROCESS_MODE_DISABLED
