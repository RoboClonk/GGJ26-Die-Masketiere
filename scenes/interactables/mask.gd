extends Interactable

@export var mask: int = 0
@export var interaction_text: String = ""

@onready var text_dialog: PanelContainer = $TextDialog

func interact() -> void:
	super()
	if interaction_text != "":
		text_dialog.show_text(interaction_text)
		await text_dialog.dialog_closed
	Globals.mask_collected.emit(mask)
	queue_free()
