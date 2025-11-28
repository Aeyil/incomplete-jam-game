extends Node

class_name GameplayManager

@export var pause_menu_scene : PackedScene = preload("res://pause_menu/pause_menu.tscn")
@export var board : ChessBoard

enum PLAYER { WHITE, BLACK }
enum TURN { ATTACK, PUSH } # ATTACK is non-pawn, Push is pawn-only

func _ready():
	for cell in board.all_cells:
		cell.cell_chosen.connect(on_cell_chosen)


func on_cell_chosen(cell_number: int):
	print(cell_number)
	# logic for moving a piece to chosen cell
	pass

func _on_pause_button_pressed():
	add_child(pause_menu_scene.instantiate())
