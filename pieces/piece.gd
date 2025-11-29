extends Node

class_name Piece

signal piece_selected(piece: Piece)
signal piece_unselected(piece: Piece)

var owning_player : Enum.PLAYER
var is_selected : bool = false
var is_selectable : bool = false

var health : float = 100.0
var damage : float = 50.0

func ready():
	SignalHub.turn_selection_phase.connect(on_turn_selection_phase)
	SignalHub.piece_selected.connect(on_piece_selected)

func set_player(player : Enum.PLAYER):
	owning_player = player
	set_texture()
	

func set_texture():
	# overridden by the pieces
	pass
	
	
func set_selectable(is_selectable: bool):
	is_selectable = is_selectable
	# TODO: Enable some sort of visual indicator
	pass
	
	
func _on_button_pressed():
	if is_selectable:
		piece_selected.emit(self)
	else: if is_selected: 
		piece_unselected.emit(self)

func take_damage(damage: float):
	health - damage
	if health <= 0:
		SignalHub.piece_died.emit(self)
		queue_free()
		

func on_piece_selected(piece: Piece):
	if self == piece:
		is_selected = true
	else:
		is_selectable = false
		
func on_turn_selection_phase(player: Enum.PLAYER, turn: Enum.TURN):
	if player == owning_player:
		if check_turn_applicability(turn):
			set_selectable(true)
			return
	set_selectable(false)

func check_turn_applicability(turn: Enum.TURN):
	# Should be overridden bei children
	return false