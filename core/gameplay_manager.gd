extends Node

class_name GameplayManager

@export var pause_menu_scene : PackedScene = preload("res://pause_menu/pause_menu.tscn")
@export var board : ChessBoard

var current_player : Enum.PLAYER
var current_turn : Enum.TURN

var selected_piece : Piece

func _ready():
	SignalHub.cell_chosen.connect(on_cell_chosen)
	SignalHub.piece_selected.connect(on_piece_selected)
	SignalHub.piece_unselected.connect(on_piece_unselected)
	start()


func start():
	SignalHub.turn_selection_phase.emit(current_player,current_turn)


func on_cell_chosen(cell: Cell):
	print(cell.cell_number)
	end_turn()


func on_piece_selected(piece : Piece):
	print("Piece selected")
	selected_piece = piece
	

func on_piece_unselected(piece : Piece):
	if selected_piece == piece:
		selected_piece = null


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
	SignalHub.turn_selection_phase.emit(current_player,current_turn)
