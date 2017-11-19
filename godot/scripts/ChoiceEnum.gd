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
	
static func Calculate_Scores(player_0_moves, player_1_moves):
	#Go through each move
	var player_0_score = 0
	var player_1_score = 0
	for move_index in range(0, player_0_moves.size()):
		#Get the moves
		var player_0_move = player_0_moves[move_index]
		var player_1_move = player_1_moves[move_index]
		
		#Did anyone win?
		var winner = Move_Wins(player_0_move, player_1_move)
		if winner == null:
			#No one won
			player_0_score -= 1
			player_1_score -= 1
			
		#Did player 0 win
		elif winner:
			player_0_score += 1
		else:
			player_1_score += 1
			
	#Return the final score
	return [player_0_score, player_1_score]
	
static func Get_Results_Per_Round(player_0_moves, player_1_moves):
	#Go through each move
	var results = []
	var player_0_score = 0
	var player_1_score = 0
	for move_index in range(0, player_0_moves.size()):
		#Get the moves
		var player_0_move = player_0_moves[move_index]
		var player_1_move = player_1_moves[move_index]
		
		#Did anyone win?
		var winner = Move_Wins(player_0_move, player_1_move)
		
		#What are their scores at that point?
		
		if winner == null:
			#No one won
			player_0_score -= 1
			player_1_score -= 1
			
		#Did player 0 win
		elif winner:
			player_0_score += 1
		else:
			player_1_score += 1
			
		#Store that information
		results.append([winner, player_0_score, player_1_score])
		
	#Return that result 'object'
	return results