extends GridContainer

class_name ChessBoard

@export var cell_columns : int = 10
@export var cell_rows : int = 10
@export var board_length : int = 800

@export var cell_object : PackedScene

# TODO: Update for other pieces
var pawn : PackedScene = preload("res://pieces/pawn.tscn")
var rook : PackedScene = preload("res://pieces/pawn.tscn")
var knight : PackedScene = preload("res://pieces/pawn.tscn")
var bishop : PackedScene = preload("res://pieces/pawn.tscn")
var queen : PackedScene = preload("res://pieces/pawn.tscn")


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
	
	
func fill_board_with_cells():
	all_cells = []
	var cell_length : float = board_length / (max(cell_columns,cell_rows))
	var last_black: bool = true
	for i in cell_rows:
		for j in cell_columns:
			var new_cell : Cell = cell_object.instantiate()
			if last_black:
				new_cell.set_color(white)
				last_black = false
			else:
				new_cell.set_color(black)
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
	for player in Enum.PLAYER:
		var spawn_counter = 0
		for amount_index in piece_amount.size()-1:
			for i in piece_amount[amount_index]-1:
				var new_piece : Piece = piece_scenes[amount_index].instantiate()
				new_piece.set_player(player)
				if player == Enum.PLAYER.WHITE:
					pieces_white.push_back(new_piece)
				else:
					pieces_black.push_back(new_piece)
				spawn_counter += 1
		print("Pieces Spawned:")
		print(spawn_counter)
	
	