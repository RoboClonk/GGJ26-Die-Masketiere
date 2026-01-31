extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(Globals.GAME)

func _on_button_settings_pressed() -> void:
	var settings_instance = Globals.SETTINGS_MENU.instantiate()
	get_tree().current_scene.add_child(settings_instance)


func _on_button_quit_pressed() -> void:
	get_tree().quit()
