extends Node

class_name GameplayManager

@export var pause_menu_scene : PackedScene = preload("res://pause_menu/pause_menu.tscn")
@export var board : ChessBoard

var current_player : Enum.PLAYER
var current_turn : Enum.TURN

var selected_piece : Piece

func _ready():
	for cell in board.all_cells:
		cell.cell_chosen.connect(on_cell_chosen)
	for piece in board.pieces_white:
		piece.piece_selected(on_piece_selected)
		piece.piece_unselected(on_piece_unselected)
	for piece in board.pieces_black:
		piece.piece_selected(on_piece_selected)
		piece.piece_unselected(on_piece_unselected)
	start()


func start():
	board.show_interaction_for_player(current_player,current_turn)

func on_cell_chosen(cell_number: int):
	print(cell_number)
	# TODO: Call logic for pieces/board interactions
	end_turn()


func on_piece_selected(piece : Piece):
	print("Piece selected")
	selected_piece = piece
	board.show_interaction_for_piece(piece)
	

func on_piece_unselected(piece : Piece):
	if selected_piece == piece:
		print("Piece unselected")
		selected_piece = null
		board.show_interaction_for_player(current_player,current_turn)


func _on_pause_button_pressed():
	add_child(pause_menu_scene.instantiate())


func end_turn():
	if current_turn == Enum.TURN.ATTACK:
		current_turn = Enum.TURN.PUSH
	else:
		if current_player == Enum.PLAYER.WHITE:
			current_player = Enum.PLAYER.BLACK
		else:
			current_player = Enum.PLAYER.WHITE
		current_turn = Enum.TURN.ATTACK
	board.show_interaction_for_player(current_player,current_turn)