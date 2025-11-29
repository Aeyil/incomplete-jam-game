extends Node


func _on_start_button_pressed():
	SignalHub.start_new_game.emit()
	pass # Replace with function body.


func _on_how_to_play_button_pressed():
	SceneManager.switch_to_tutorial()
	pass # Replace with function body.
	

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
