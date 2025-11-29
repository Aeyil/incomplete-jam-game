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

var selected_piece : Piece

var black : Color = Color(0,0,0)
var white : Color = Color(255,255,255)

var all_cells : Array[Cell] =[]

var pieces_white : Array[Piece] = []
var pieces_black : Array[Piece] = []

func _ready():
	columns = cell_columns
	
	SignalHub.piece_died.connect(on_piece_died)
	SignalHub.piece_selected.connect(on_piece_selected)
	SignalHub.piece_unselected.connect(on_piece_unselected)
	SignalHub.cell_chosen.connect(on_cell_chosen)
	
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
			new_cell.cell_row = i
			new_cell.cell_column = j
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
			

func on_piece_died(piece: Piece):
	if piece.owning_player == Enum.PLAYER.WHITE:
		pieces_white.erase(piece)
	else:
		pieces_black.erase(piece)
		
func on_hover_cell(cell: Cell):
	# TODO: Show damage preview if selected piece is attack piece
	pass
		
func on_piece_selected(piece: Piece):
	selected_piece = piece
	# Set all posible destionations to be possibly interactable
	if piece is Pawn:
		interactables_for_pawn(piece)
	elif piece is Rook:
		interactables_for_rook(piece)
	elif piece is Knight:
		interactables_for_knight(piece)
	elif piece is Bishop:
		interactables_for_bishop(piece)
	elif piece is Queen:
		interactables_for_queen(piece)
	
	
func on_piece_unselected(piece: Piece):
	selected_piece = null


func on_cell_chosen(cell : Cell):
	if selected_piece is Pawn:
		var won : bool = false
		if selected_piece.owning_player == Enum.PLAYER.WHITE and cell.cell_column == cell_columns - 1:
			won = true
		elif selected_piece.owning_player == Enum.PLAYER.BLACK and cell.cell_column == 0:
			won = true
		if won:
			SceneManager.switch_to_end_screen(selected_piece.owning_player)
	if !(selected_piece is Pawn):
		deal_damage(selected_piece, cell, selected_piece.occupied_cell)
	cell.move_piece(selected_piece)
	selected_piece = null
	
func interactables_for_pawn(piece: Piece):
	var piece_loc : int = piece.occupied_cell.cell_number
	var possible_indices: Array[int] = []
	if selected_piece.owning_player == Enum.PLAYER.WHITE:
		possible_indices.push_back(piece_loc+1)
	else:
		possible_indices.push_back(piece_loc-1)
	possible_indices.push_back(piece_loc-cell_columns)
	possible_indices.push_back(piece_loc+cell_columns)
	for index in possible_indices:
		if(index >= 0 and index < all_cells.size()):
			all_cells[index].set_interactable(true)
	
func interactables_for_rook(piece: Piece):
	var piece_loc : int = piece.occupied_cell.cell_number
	var nextIndex = piece_loc-1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null and all_cells[nextIndex].cell_row == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		nextIndex -= 1
	nextIndex = piece_loc+1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null and all_cells[nextIndex].cell_row == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		nextIndex += 1
	nextIndex = piece_loc+cell_columns
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null and all_cells[nextIndex].cell_column == piece.occupied_cell.cell_column:
		all_cells[nextIndex].set_interactable(true)
		nextIndex += cell_columns
	nextIndex = piece_loc-cell_columns
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null and all_cells[nextIndex].cell_column == piece.occupied_cell.cell_column:
		all_cells[nextIndex].set_interactable(true)
		nextIndex -= cell_columns
		

func interactables_for_knight(piece: Piece):
	var piece_loc : int = piece.occupied_cell.cell_number
	var index = piece_loc - 2*cell_columns-1
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row + 2 == piece.occupied_cell.cell_row and all_cells[index].cell_column + 1 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc - 2*cell_columns+1
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row + 2 == piece.occupied_cell.cell_row and all_cells[index].cell_column - 1 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc - cell_columns-2
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row + 1 == piece.occupied_cell.cell_row and all_cells[index].cell_column + 2 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc - cell_columns+2
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row + 1 == piece.occupied_cell.cell_row and all_cells[index].cell_column - 2 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc + cell_columns-2
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row - 1 == piece.occupied_cell.cell_row and all_cells[index].cell_column + 2 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc + cell_columns+2
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row - 1 == piece.occupied_cell.cell_row and all_cells[index].cell_column - 2 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc + 2*cell_columns-1
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row - 2 == piece.occupied_cell.cell_row and all_cells[index].cell_column + 1 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
	index = piece_loc + 2*cell_columns+1
	if index >= 0 and index < all_cells.size() and all_cells[index].current_piece == null \
	and all_cells[index].cell_row - 2 == piece.occupied_cell.cell_row and all_cells[index].cell_column - 1 == piece.occupied_cell.cell_column:
		all_cells[index].set_interactable(true)
		
		
	
func interactables_for_bishop(piece: Piece):
	var piece_loc : int = piece.occupied_cell.cell_number
	var nextIndex = piece_loc - cell_columns - 1
	var offset = 1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null \
	and all_cells[nextIndex].cell_column + offset == piece.occupied_cell.cell_column and all_cells[nextIndex].cell_row + offset == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		offset += 1
		nextIndex -= (cell_columns +1)
	nextIndex = piece_loc - cell_columns + 1
	offset = 1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null \
	and all_cells[nextIndex].cell_column - offset == piece.occupied_cell.cell_column and all_cells[nextIndex].cell_row + offset == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		offset += 1
		nextIndex -= (cell_columns - 1)
	nextIndex = piece_loc + cell_columns - 1
	offset = 1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null \
	and all_cells[nextIndex].cell_column + offset == piece.occupied_cell.cell_column and all_cells[nextIndex].cell_row - offset == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		offset += 1
		nextIndex += cell_columns -1
	nextIndex = piece_loc + cell_columns + 1
	offset = 1
	while nextIndex >= 0 and nextIndex < all_cells.size() and all_cells[nextIndex].current_piece == null \
	and all_cells[nextIndex].cell_column - offset == piece.occupied_cell.cell_column and all_cells[nextIndex].cell_row - offset == piece.occupied_cell.cell_row:
		all_cells[nextIndex].set_interactable(true)
		offset += 1
		nextIndex += cell_columns +1
	pass
	
func interactables_for_queen(piece: Piece):
	interactables_for_rook(piece)
	interactables_for_bishop(piece)
	
func deal_damage(piece: Piece, new_cell : Cell, old_cell : Cell):
	var cells : Array[Cell] = get_damagable_cells_for_move(piece, new_cell, old_cell)
	for cell in cells:
		if cell.current_piece != null and cell.current_piece.owning_player != piece.owning_player:
			cell.current_piece.take_damage(piece.damage)
		

func get_damagable_cells_for_move(piece: Piece, new_cell: Cell, old_cell: Cell) -> Array[Cell]:
	if piece is Rook:
		return damagable_cells_for_rook(piece, new_cell, old_cell)
	elif piece is Knight:
		return damagable_cells_for_knight(piece, new_cell, old_cell)
	elif piece is Bishop:
		return damagable_cells_for_bishop(piece, new_cell, old_cell)
	elif piece is Queen:
		return damagable_cells_for_queen(piece, new_cell, old_cell)
	return []
		

func damagable_cells_for_rook(piece: Piece, new_cell: Cell, old_cell: Cell) -> Array[Cell]:
	var cells : Array[Cell] = []
	var index : int = 0
	if new_cell.cell_column == old_cell.cell_column and new_cell.cell_row < old_cell.cell_row:
		index = new_cell.cell_number - cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column +1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - cell_columns
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if new_cell.cell_column == old_cell.cell_column and new_cell.cell_row > old_cell.cell_row:
		index = new_cell.cell_number + cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if new_cell.cell_column > old_cell.cell_column and new_cell.cell_row == old_cell.cell_row:
		index = new_cell.cell_number - cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column +1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if new_cell.cell_column < old_cell.cell_column and new_cell.cell_row == old_cell.cell_row:
		index = new_cell.cell_number - cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	return cells
	

func damagable_cells_for_knight(piece: Piece, new_cell: Cell, old_cell: Cell) -> Array[Cell]:
	var cells : Array[Cell] = []
	var index : int = 0
	if (old_cell.cell_row - 2 == new_cell.cell_row and old_cell.cell_column - 1 == new_cell.cell_column) or \
	(old_cell.cell_row - 1 == new_cell.cell_row and old_cell.cell_column - 2 == new_cell.cell_column):
		index = new_cell.cell_number - cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column +1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - cell_columns
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if (old_cell.cell_row - 2 == new_cell.cell_row and old_cell.cell_column + 1 == new_cell.cell_column) or \
	(old_cell.cell_row - 1 == new_cell.cell_row and old_cell.cell_column + 2 == new_cell.cell_column):
		index = new_cell.cell_number - cell_columns
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number - cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if (old_cell.cell_row + 1 == new_cell.cell_row and old_cell.cell_column - 2 == new_cell.cell_column) or \
	(old_cell.cell_row + 2 == new_cell.cell_row and old_cell.cell_column - 1 == new_cell.cell_column):
		index = new_cell.cell_number - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
	if (old_cell.cell_row + 1 == new_cell.cell_row and old_cell.cell_column + 2 == new_cell.cell_column) or \
	(old_cell.cell_row + 2 == new_cell.cell_row and old_cell.cell_column + 1 == new_cell.cell_column):
		index = new_cell.cell_number + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column == new_cell.cell_column:
			cells.push_back(all_cells[index])
		index = new_cell.cell_number + cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
	return cells
	
	
func damagable_cells_for_bishop(piece: Piece, new_cell: Cell, old_cell: Cell) -> Array[Cell]:
	var cells : Array[Cell] = []
	var index : int = 0
	if new_cell.cell_column < old_cell.cell_column and new_cell.cell_row < old_cell.cell_row:
		var big_attack : bool = new_cell.cell_column + 3 <= old_cell.cell_column
		index = new_cell.cell_number - cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column +1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		if big_attack:
			index = new_cell.cell_number - 2*cell_columns - 2
			if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 2 == new_cell.cell_row \
			and all_cells[index].cell_column +2 == new_cell.cell_column:
				cells.push_back(all_cells[index])
	if new_cell.cell_column > old_cell.cell_column and new_cell.cell_row < old_cell.cell_row:
		var big_attack : bool = new_cell.cell_column - 3 >= old_cell.cell_column
		index = new_cell.cell_number - cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		if big_attack:
			index = new_cell.cell_number - 2*cell_columns + 2
			if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 2 == new_cell.cell_row \
			and all_cells[index].cell_column - 2 == new_cell.cell_column:
				cells.push_back(all_cells[index])
	if new_cell.cell_column < old_cell.cell_column and new_cell.cell_row > old_cell.cell_row:
		var big_attack : bool = new_cell.cell_column + 3 >= old_cell.cell_column
		index = new_cell.cell_number + cell_columns - 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column + 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		if big_attack:
			index = new_cell.cell_number + 2*cell_columns - 2
			if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 2 == new_cell.cell_row \
			and all_cells[index].cell_column + 2 == new_cell.cell_column:
				cells.push_back(all_cells[index])
	if new_cell.cell_column > old_cell.cell_column and new_cell.cell_row > old_cell.cell_row:
		var big_attack : bool = new_cell.cell_column - 3 >= old_cell.cell_column
		index = new_cell.cell_number + cell_columns + 1
		if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
		and all_cells[index].cell_column - 1 == new_cell.cell_column:
			cells.push_back(all_cells[index])
		if big_attack:
			index = new_cell.cell_number + 2*cell_columns + 2
			if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 2 == new_cell.cell_row \
			and all_cells[index].cell_column - 2 == new_cell.cell_column:
				cells.push_back(all_cells[index])
	return cells
	
	
func damagable_cells_for_queen(piece: Piece, new_cell: Cell, old_cell: Cell) -> Array[Cell]:
	var cells : Array[Cell] = []
	var index : int = new_cell.cell_number - cell_columns - 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
	and all_cells[index].cell_column +1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number - cell_columns
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
	and all_cells[index].cell_column == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number - cell_columns + 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row + 1 == new_cell.cell_row \
	and all_cells[index].cell_column - 1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number - 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
	and all_cells[index].cell_column + 1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number + 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row == new_cell.cell_row \
	and all_cells[index].cell_column - 1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number + cell_columns - 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
	and all_cells[index].cell_column + 1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number + cell_columns
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
	and all_cells[index].cell_column == new_cell.cell_column:
		cells.push_back(all_cells[index])
	index = new_cell.cell_number + cell_columns + 1
	if index > 0 and index < all_cells.size() and all_cells[index].cell_row - 1 == new_cell.cell_row \
	and all_cells[index].cell_column - 1 == new_cell.cell_column:
		cells.push_back(all_cells[index])
	return cells
	