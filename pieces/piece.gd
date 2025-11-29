extends Node

class_name Piece

signal piece_selected(piece: Piece)
signal piece_unselected(piece: Piece)

var owning_player : Enum.PLAYER

func set_player(player : Enum.PLAYER):
	owning_player = player