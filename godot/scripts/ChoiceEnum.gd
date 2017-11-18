

#Make the enum
enum MOVES {
	NEUTRAL,
	ROCK,
	PAPER,
	SCISSORS,
}

static func Move_Wins(my_move, opponent_move):
	#Did we pick the same thing?
	if my_move == opponent_move:
		return null
	
	#Figure it out
	
	#Neutral moves
	if my_move == MOVES.NEUTRAL:
		#We lost
		return false
	if opponent_move == MOVES.NEUTRAL:
		#We win
		return true
		
	#Regular moves
	if my_move == Find_Winning_Move(opponent_move):
		return true
	
	#If we didn't tie, and we didn't win, then we must have lost
	return false
	 
static func Find_Winning_Move(losing_move):
	#Pick the right move
	if losing_move == MOVES.ROCK:
		return MOVES.PAPER
	if losing_move == MOVES.PAPER:
		return MOVES.SCISSORS
	if losing_move == MOVES.SCISSORS:
		return MOVES.ROCK
	
	#If it's arbitrary, just pick rock because they ROCK!
	return MOVES.ROCK