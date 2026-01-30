extends Collectible

func collected_by_player(player: Player) -> void:
	print("Money ++")
	queue_free()
