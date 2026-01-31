extends Control

@onready var main_menu: VBoxContainer = $VBoxContainer/MarginBox/MainMenu
@onready var settings_menu: VBoxContainer = $VBoxContainer/SettingsMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bitowl/levels/test_level.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings_menu.visible = true


func _on_settings_back_pressed() -> void:
	settings_menu.visible = false
	main_menu.visible = true
