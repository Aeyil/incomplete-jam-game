extends Piece

class_name Bishop

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.ATTACK
