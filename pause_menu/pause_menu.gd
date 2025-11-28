extends Node


func _on_button_pressed():
	SignalHub.end_current_game.emit()
	pass # Replace with function body.
