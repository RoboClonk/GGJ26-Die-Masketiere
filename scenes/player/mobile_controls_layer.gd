extends CanvasLayer

@export var control_frame: TextureRect
@export var control_knob: TextureRect
@export var control_center: Control
@export var interface: Control
@export var attack_button: Button


var is_dragging = false
var index_dragging = -1

func _ready() -> void:
	if OS.has_feature("editor"):
		return
	
	if !Globals.is_mobile():
		queue_free()


func _process(delta: float) -> void:
	layer = -1 if interface.pause_menu.visible else 1


func get_knob_position(in_touch_position : Vector2):
	return (in_touch_position - control_frame.position  - control_frame.size / 2).limit_length(control_frame.size.x / 2)


func is_touch_within_control(in_position : Vector2, control : Control):
	if (in_position.x < control.position.x + control.size.x 
		and in_position.x > control.position.x
		and in_position.y < control.position.y + control.size.y
		and in_position.y > control.position.y):
		return true
	return false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch : InputEventScreenTouch = event
		if touch.is_pressed():
			if is_touch_within_control(touch.position, attack_button):
				Input.action_press("Attack") # For interactables
				if Player.player:
					Player.player.trigger_attack()
				
		if touch.is_pressed() and !is_dragging:
			if is_touch_within_control(touch.position, control_frame):
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
