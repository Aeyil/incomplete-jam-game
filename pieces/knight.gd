extends Piece

class_name Knight

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK