extends Interactable

@export var mask: int = 0

func interact() -> void:
	super()
	Globals.mask_collected.emit(mask)
	queue_free()
