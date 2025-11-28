extends Node


func _on_start_button_pressed():
	SignalHub.start_new_game.emit()
	pass # Replace with function body.


func _on_how_to_play_button_pressed():
	# Switch to HowToPlay Screen
	pass # Replace with function body.
