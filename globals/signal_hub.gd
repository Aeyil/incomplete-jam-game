extends Node

signal start_new_game()
signal end_current_game()

signal turn_selection_phase(player : Enum.PLAYER, turn: Enum.TURN)
signal piece_selected(piece : Piece)
signal piece_unselected(piece : Piece)
signal cell_chosen(cell_number : int)
signal piece_died(piece : Piece)


func _ready():
	turn_selection_phase.connect(on_turn_selection_phase)
	piece_selected.connect(on_piece_selected)
	piece_unselected.connect(on_piece_unselected)
	cell_chosen.connect(on_cell_chosen)
	piece_died.connect(on_piece_died)
	
	
func on_turn_selection_phase(player : Enum.PLAYER, turn: Enum.TURN):
	print("TURN_SELECTION_PHASE fired.")
	

func on_piece_selected(piece : Piece):
	print("PIECE_SELECTED fired.")
	
func on_piece_unselected(piece : Piece):
	print("PIECE_UNSELECTED fired.")

func on_cell_chosen(cell_number : int):
	print("CELL_CHOSEN fired.")
	
func on_piece_died(piece : Piece):
	print("PIECE_DIED fired.")