extends Piece

class_name Queen

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK
