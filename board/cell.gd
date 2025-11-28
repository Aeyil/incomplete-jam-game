extends Panel

class_name Cell

signal cell_chosen(cell_number: int)

@export var cell_button : Button

var current_piece : Piece
var cell_number : int = 0

func set_color(color : Color):
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = color
	cell_button.add_theme_stylebox_override("normal",stylebox)

	
func set_length(length : float):
	custom_minimum_size = Vector2(length,length)
	

func set_interactable(is_interactable : bool):
		cell_button.disabled = !is_interactable || current_piece == null
		if is_interactable: 
			show_interaction_overlay() 
		else: 
			hide_interation_overlay()
		

func move_piece(piece: Piece):
	current_piece = piece
	set_interactable(false)		


func show_interaction_overlay():
	pass
	
	
func hide_interation_overlay():
	pass
	

func show_damage_overlay():
	pass
	
	
func hide_damage_overlay():
	pass
	


func _on_interactable_button_pressed():
	cell_chosen.emit(cell_number)
