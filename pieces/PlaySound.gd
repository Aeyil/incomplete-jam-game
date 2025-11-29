extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.cell_chosen.connect(Play_sound)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Play_sound(cell:Cell) -> void:
	if GameData.selected_piece == self.get_parent():
		play()
	pass
