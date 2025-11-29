extends GridContainer

class_name ChessBoard

@export var cell_columns : int = 10
@export var cell_rows : int = 10
@export var board_length : int = 800

@export var cell_object : PackedScene

# TODO: Update for other pieces
var pawn : PackedScene = preload("res://pieces/pawn.tscn")
var rook : PackedScene = preload("res://pieces/rook.tscn")
var knight : PackedScene = preload("res://pieces/knight.tscn")
var bishop : PackedScene = preload("res://pieces/bishop.tscn")
var queen : PackedScene = preload("res://pieces/queen.tscn")


var piece_amount: Array[int] = [8,2,2,2,1]
var piece_scenes: Array[PackedScene] = [pawn, rook, knight, bishop, queen]

var black : Color = Color(0,0,0)
var white : Color = Color(255,255,255)

var all_cells : Array[Cell] =[]

var pieces_white : Array[Piece] = []
var pieces_black : Array[Piece] = []

func _ready():
	columns = cell_columns
	fill_board_with_cells()
	spawn_pieces()
	add_pieces_to_board()
	
	
func fill_board_with_cells():
	all_cells = []
	var cell_length : float = board_length / (max(cell_columns,cell_rows))
	var last_black: bool = true
	for i in cell_rows:
		for j in cell_columns:
			var new_cell : Cell = cell_object.instantiate()
			if last_black:
				new_cell.set_color(white, Enum.CELLTYPE.WHITE)
				last_black = false
			else:
				new_cell.set_color(black, Enum.CELLTYPE.BLACK)
				last_black = true
			new_cell.set_length(cell_length)
			new_cell.cell_number = i*cell_columns + j
			add_child(new_cell)
			all_cells.push_back(new_cell)
		if cell_columns % 2 == 0:
			last_black = !last_black


func spawn_pieces():
	pieces_white = []
	pieces_black = []
	for player in Enum.PLAYER.values():
		var spawn_counter = 0
		for amount_index in piece_amount.size():
			print("Amount Index")
			print(amount_index)
			for i in piece_amount[amount_index]:
				print("i")
				print(i)
				var new_piece : Piece = piece_scenes[amount_index].instantiate()
				new_piece.set_player(player)
				if player == Enum.PLAYER.WHITE:
					pieces_white.push_back(new_piece)
				else:
					pieces_black.push_back(new_piece)
				spawn_counter += 1
		print("Pieces Spawned:")
		print(spawn_counter)
	
	
func add_pieces_to_board():
	var rows_needed : int = ceil(pieces_white.size()/2.0)
	if cell_rows < rows_needed:
		print("Not enough rows to house pieces")
		return
	if cell_columns < 6:
		print("Not enough columns for gameplay")
		return
	
	var right_offset : int = cell_columns - 1
	var anchor_position = (cell_rows/2 - rows_needed/2)*cell_columns
	var piece_index = 0
	# Add Pawns
	var curr_pos_pawn = anchor_position 
	while pieces_white[piece_index] is Pawn:
		print("Placing Pawn...")
		print("on")
		print(curr_pos_pawn)
		all_cells[curr_pos_pawn].move_piece(pieces_white[piece_index])
		curr_pos_pawn += right_offset
		all_cells[curr_pos_pawn].move_piece(pieces_black[piece_index])
		curr_pos_pawn += 1
		piece_index += 1
		if piece_index > pieces_white.size()-1:
			return
	# Add Rooks
	var outer_offset = 0
	var last_top : bool = false
	while pieces_white[piece_index] is Rook:
		print("Placing Rook...")
		if last_top:
			var curr_pos = anchor_position + (rows_needed-1) * cell_columns - outer_offset * cell_columns
			print("on")
			print(curr_pos+1)
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = false
			outer_offset += 1
		else:
			var curr_pos = anchor_position + outer_offset * cell_columns
			print("on")
			print(curr_pos+1)
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = true
		piece_index += 1
	# Add Knights
	while pieces_white[piece_index] is Knight:
		print("Placing Knight...")
		if last_top:
			var curr_pos = anchor_position + (rows_needed-1) * cell_columns - outer_offset * cell_columns
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = false
			outer_offset += 1
		else:
			var curr_pos = anchor_position + outer_offset * cell_columns
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = true
		piece_index += 1
	# Add Bishops
	while pieces_white[piece_index] is Bishop:
		print("Placing Bishop...")
		if last_top:
			var curr_pos = anchor_position + (rows_needed-1) * cell_columns - outer_offset * cell_columns
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = false
			outer_offset += 1
		else:
			var curr_pos = anchor_position + outer_offset * cell_columns
			all_cells[curr_pos+1].move_piece(pieces_white[piece_index])
			all_cells[curr_pos+right_offset-1].move_piece(pieces_black[piece_index])
			last_top = true
		piece_index += 1
	# Add Queen
	if pieces_white[piece_index] is Queen:
		print("Placing Queen...")
		if rows_needed % 2 == 0:
			var queen_upper_anchor_pos = anchor_position + (rows_needed/2 - 1) * cell_columns
			if all_cells[queen_upper_anchor_pos + 1].cell_type == Enum.CELLTYPE.WHITE:
				all_cells[queen_upper_anchor_pos + 1].move_piece(pieces_white[piece_index])
			else:
				all_cells[queen_upper_anchor_pos + cell_columns + 1].move_piece(pieces_white[piece_index])
			if all_cells[queen_upper_anchor_pos + right_offset - 1].cell_type == Enum.CELLTYPE.BLACK:
				all_cells[queen_upper_anchor_pos + right_offset - 1].move_piece(pieces_black[piece_index])
			else:
				all_cells[queen_upper_anchor_pos + right_offset + cell_columns - 1].move_piece(pieces_black[piece_index])
		else:
			var queen_anchor_pos = anchor_position + (rows_needed/2) * cell_columns
			all_cells[queen_anchor_pos + 1].move_piece(pieces_white[piece_index])
			all_cells[queen_anchor_pos + right_offset - 1].move_piece(pieces_black[piece_index])
			
	
func show_interaction_for_player(player : Enum.PLAYER, turn : Enum.TURN):
	pass 
	
	
func show_interaction_for_piece(piece : Piece):
	pass
