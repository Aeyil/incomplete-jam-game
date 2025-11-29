extends Piece

class_name Knight

func set_texture():
	if owning_player == Enum.PLAYER.WHITE:
		texture.flip_h = true
		texture.texture = white_texture
	else: if owning_player == Enum.PLAYER.BLACK:
		texture.texture = black_texture

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK