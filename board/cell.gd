extends Panel

class_name Cell

@export var cell_button : Button

var current_piece : Piece
var cell_number : int = 0
var cell_row : int = 0
var cell_column : int = 0
var cell_type : Enum.CELLTYPE

var is_possibly_interactable : bool

func _ready():
	SignalHub.piece_died.connect(on_piece_died)
	SignalHub.piece_unselected.connect(on_piece_unselected)
	SignalHub.cell_chosen.connect(on_cell_chosen)
	update_interaction()

func set_color(color : Color, type : Enum.CELLTYPE):
	cell_type = type
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = color
	cell_button.add_theme_stylebox_override("normal",stylebox)

	
func set_length(length : float):
	custom_minimum_size = Vector2(length,length)
	

func set_interactable(is_interactable : bool):
	is_possibly_interactable = is_interactable
	update_interaction()
	

func update_interaction():
	if is_possibly_interactable and current_piece == null: 
		show_interaction_overlay() 
		cell_button.disabled = false
	else: 
		hide_interation_overlay()
		cell_button.disabled = true
		

func move_piece(piece: Piece):
	if piece.occupied_cell != null:
		piece.occupied_cell.remove_child(piece)
		piece.occupied_cell.current_piece = null
	current_piece = piece
	piece.occupied_cell = self
	set_interactable(false)
	add_child(current_piece)


func show_interaction_overlay():
	pass
	
	
func hide_interation_overlay():
	pass
	

func show_damage_overlay():
	pass
	
	
func hide_damage_overlay():
	pass
	


func _on_interactable_button_pressed():
	SignalHub.cell_chosen.emit(self)


func on_piece_died(piece: Piece):
	if current_piece == piece:
		current_piece = null
		update_interaction()
		
		
func on_piece_unselected(piece : Piece):
	is_possibly_interactable = false
	update_interaction()
	
func on_cell_chosen(cell: Cell):
	set_interactable(false)