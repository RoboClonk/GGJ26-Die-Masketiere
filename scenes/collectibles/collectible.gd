extends Area2D

class_name Collectible


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		collected_by_player(body)

# Override this function with the collected logic. 
func collected_by_player(player: Player) -> void:
	print("Collected.")
	queue_free()
