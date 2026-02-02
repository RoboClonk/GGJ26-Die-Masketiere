extends CanvasLayer

@export var control_frame: TextureRect
@export var control_knob: TextureRect
@export var control_center: Control
@export var interface: Control

var is_dragging = false
var index_dragging = -1

func _ready() -> void:
	if OS.has_feature("editor"):
		return
	
	if OS.get_name() != "Android" and OS.get_name() != "iOS":
		queue_free()


func _process(delta: float) -> void:
	layer = -1 if interface.pause_menu.visible else 1


func get_knob_position(in_touch_position : Vector2):
	return (in_touch_position - control_frame.position  - control_frame.size / 2).limit_length(control_frame.size.x / 2)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch : InputEventScreenTouch = event
		if touch.is_pressed() and !is_dragging:
			if (touch.position.x < control_frame.position.x + control_frame.size.x 
			and touch.position.x > control_frame.position.x
			and touch.position.y < control_frame.position.y + control_frame.size.y
			and touch.position.y > control_frame.position.y):
				is_dragging = true
				index_dragging = touch.index
			
				var control_direction : Vector2 = get_knob_position(touch.position)
				control_knob.position = control_direction
		
		if touch.is_released() and is_dragging and index_dragging == touch.index:
			is_dragging = false
			index_dragging = -1
			control_knob.position = Vector2.ZERO
			update_control_direction(Vector2.ZERO)
			
	if event is InputEventScreenDrag:
		var touch : InputEventScreenDrag = event
		if is_dragging and touch.index == index_dragging:
			var control_direction : Vector2 = get_knob_position(touch.position)
			control_knob.position = control_direction
			update_control_direction(control_direction.normalized())
			#print("Knob: %v Touch: %v" % [control_knob.position, touch.position])


func update_control_direction(in_vector : Vector2):
	if Player.player:
		Player.player.mobile_control_vector = in_vector


func _on_attack_button_button_down() -> void:
	Input.action_press("Attack") # Emulate input for interactables
