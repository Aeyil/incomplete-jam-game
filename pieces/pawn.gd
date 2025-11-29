extends Piece

class_name Pawn

func check_turn_applicability(turn: Enum.TURN):
	return turn == Enum.TURN.PUSH
