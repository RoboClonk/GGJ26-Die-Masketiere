extends PanelContainer

signal dialog_closed()

@export var text_delay: float = 0.02
@onready var label: Label = $MarginContainer/Label

var is_quittable: bool = false

func show_text(text: String) -> void:
	is_quittable = false
	label.text = text
	label.visible_characters = 0
	get_tree().paused = true
	show()
	var total_characters = text.length()
	for i in total_characters + 1:
		is_quittable = true
		label.visible_characters = i
		await get_tree().create_timer(text_delay).timeout
		if Input.is_action_just_pressed("Attack"):
			label.visible_characters = -1
			await get_tree().process_frame
			break


func _process(_delta: float) -> void:
	if label.visible_ratio >= 1 and is_quittable:
		if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Pause"):
			get_tree().paused = false
			hide()
			dialog_closed.emit()
