extends Piece

class_name Rook

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK
