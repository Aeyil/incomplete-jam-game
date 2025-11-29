extends Piece

class_name Rook

@export var white_texture : Texture
@export var black_texture : Texture

@export var texture : TextureRect

func set_texture():
	if owning_player == Enum.PLAYER.WHITE:
		# texture.texture = white_texture
		pass
	else: if owning_player == Enum.PLAYER.BLACK:
		# texture.texture = black_texture
		pass
		

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK
