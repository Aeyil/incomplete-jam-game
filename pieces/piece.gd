extends Node

class_name Piece

@export var white_texture : Texture
@export var black_texture : Texture
@export var button : Button
@export var texture : TextureRect

var occupied_cell : Cell
var owning_player : Enum.PLAYER

var is_selected : bool = false
var is_selectable : bool = false
var is_selectable_in_turn : bool = false

@export var health : float = 100.0
@export var damage : float = 50.0

func _ready():
	SignalHub.turn_selection_phase.connect(on_turn_selection_phase)
	SignalHub.piece_selected.connect(on_piece_selected)
	SignalHub.piece_unselected.connect(on_piece_unselected)
	SignalHub.cell_chosen.connect(on_cell_chosen)
	set_selectable(false)

func set_player(player : Enum.PLAYER):
	owning_player = player
	set_texture()
	

func set_texture():
	if owning_player == Enum.PLAYER.WHITE:
		texture.texture = white_texture
	else: if owning_player == Enum.PLAYER.BLACK:
		texture.texture = black_texture
	
	
func set_selectable(selectable: bool):
	is_selectable = selectable
	button.disabled = !is_selectable
	
	
func _on_button_pressed():
	if is_selected:
		SignalHub.piece_unselected.emit(self)
	else: if is_selectable: 
		SignalHub.piece_selected.emit(self)

func take_damage(damage_taken: float):
	print("damage taken!")
	health -= damage_taken
	if health <= 0:
		SignalHub.piece_died.emit(self)
		queue_free()
		

func on_piece_selected(piece: Piece):
	if self == piece:
		is_selected = true
	else:
		is_selectable = false
		
func on_piece_unselected(piece: Piece):
	if piece == self:
		is_selected = false
	if is_selectable_in_turn:
		set_selectable(true)
		
		
func on_cell_chosen(cell: Cell):
	if is_selected:
		occupied_cell = cell
		is_selected = false
		
func on_turn_selection_phase(player: Enum.PLAYER, turn: Enum.TURN):
	if player == owning_player:
		if check_turn_applicability(turn):
			is_selectable_in_turn = true
			set_selectable(true)
			return
	is_selectable_in_turn = false
	set_selectable(false)

func check_turn_applicability(turn: Enum.TURN):
	# Should be overridden bei children
	return false