extends Sprite

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Find the players
onready var player_0 = get_node("../Player0")
onready var player_1 = get_node("../Player1")
onready var timer = get_node("./Timer")

#Debug
onready var debug_text = get_node("./TimeDebug")

#Is player 1 AI?
var player_1_AI = true
var player_1_difficulty = true

#Stuff related to rounds
var current_round = 0
var total_rounds = 35
var latest_winner = null
var latest_player0_move = null
var latest_player1_move = null

#Stuff related to tempo and music
var start_tempo =  100 #BPM
var current_tempo = start_tempo
var tempo_increase_cadence = 4 #How many rounds
var tempo_increase_amount = 25 #BPM
var beat_count = 0

#Sounds
onready var tone1 = load("res://objects/GameController/Tone1.ogg")
onready var tone24 = load("res://objects/GameController/Tone2-4.ogg")
onready var tone3 = load("res://objects/GameController/Tone3.ogg")
onready var tone5 = load("res://objects/GameController/Tone5.ogg")
onready var tone6 = load("res://objects/GameController/Tone6.ogg")
onready var win1 = load("res://objects/GameController/Win1.ogg")
onready var win2 = load("res://objects/GameController/Win2.ogg")
onready var lose = load("res://objects/GameController/Lose.ogg")
var sfx_dict = {}
var sfx_node_dict = {}
onready var tween = get_node("./Tween")

#Some sprites
onready var sprite_player_win = load("res://objects/GameController/player_win.png")
onready var sprite_no_win = load("res://objects/GameController/no_win.png")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#Are we on debug?
	if global.DEBUG:
		current_tempo = 2000
		player_0.call_deferred("set_AI", true, true)
	
	#Set up all the sound madness
	sfx_dict = {
	'Tone1': tone1,
	'Tone24': tone24,
	'Tone3': tone3,
	'Tone5': tone5,
	'Tone6': tone6,
	'Win1': win1,
	'Win2': win2,
	'Lose': lose,
	}
	
	#Make SFX objects for each
	for sfx in sfx_dict:
		#Make the node, set it up, and add it
		var new_sfx_node = StreamPlayer.new()
		new_sfx_node.set_stream(sfx_dict[sfx])
		new_sfx_node.set_autoplay(false)
		add_child(new_sfx_node)
		
		#Track the node
		sfx_node_dict[sfx] = new_sfx_node
	
	#grab the player setup
	player_1_AI = global.player_1_AI
	player_1_difficulty = global.player_1_difficulty
	
	#Lets update player 1 if needed
	player_1.call_deferred("set_AI", player_1_AI, player_1_difficulty)
	
	#Set the AI for both for now
	#player_0.call_deferred("set_AI", true, false)
	
	
	#Kick off the timer
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timer_timeout_tempo")
	handle_timer()

func handle_timer():
	#How long till the next beat?
	var beat_time = 60.0 / current_tempo
	var half_beat_time = beat_time / 2
	
	#And increment the counter and set the time
	timer.set_wait_time(beat_time)
	
	#Fire off the timer
	timer.start()
	
	#Update some debug stuff 
	if global.DEBUG:
		var text = "R:" + str(current_round) + " B:" + str(beat_count) + " T:" + str(current_tempo)
		debug_text.set_text(text)
	
func _on_timer_timeout_tempo():
	#How long till the next beat?
	var beat_time = 60.0 / current_tempo
	var half_beat_time = beat_time / 2
	
	#Clear the tween
	tween.remove_all()
	
	#Which beat were we on?
	if beat_count == 0:
		#We can play the noise
		_play_sfx("Tone1")
		tween.interpolate_deferred_callback(self, half_beat_time, "_play_sfx", "Tone24")
		set_texture(null)
		
		#Reset player sprites
		player_0.change_sprite(MOVES.NEUTRAL)
		player_1.change_sprite(MOVES.NEUTRAL)
		
	elif beat_count == 1:
		#Play the same noise
		_play_sfx("Tone3")
		tween.interpolate_deferred_callback(self, half_beat_time, "_play_sfx", "Tone24")
	elif beat_count == 2:
		#Play the different noise
		_play_sfx("Tone5")
		tween.interpolate_deferred_callback(self, half_beat_time, "_play_sfx", "Tone6")
		
		#We need to get the moves for each player
		#Also reset their moves
		latest_winner = get_winner()
		
	elif beat_count == 3:
		
		#Let the players show what they picked
		player_0.change_sprite(latest_player0_move)
		player_1.change_sprite(latest_player1_move)
		
		#Updade the AI if needed
		player_0.give_result_AI(latest_player1_move)
		player_1.give_result_AI(latest_player0_move)
		
		#Play the sound for the winner
		if latest_winner == null:
			#No one wins!
			_play_sfx("Lose")
			set_texture(sprite_no_win)
			set_modulate(global.FAIL_COLOR)
			
		elif latest_winner:
			#Player 0 won
			_play_sfx("Win1")
			set_texture(sprite_player_win)
			var scale = get_scale()
			scale.x = abs(scale.x)
			set_scale(scale)
			set_modulate(global.PLAYER_0_TINT)
		else:
			#Player 1 win
			_play_sfx("Win2")
			set_texture(sprite_player_win)
			var scale = get_scale()
			scale.x = -abs(scale.x)
			set_scale(scale)
			set_modulate(global.PLAYER_1_TINT)
		
		#Did we finish the game?
		current_round += 1
		if current_round >= total_rounds:
			#We're done
			get_tree().change_scene("res://scenes/Score.tscn")
			return
		
		#Do we increase tempo?
		if current_round % tempo_increase_cadence == 0:
			current_tempo += tempo_increase_amount
		
		#Reset the counter
		beat_count = -1
	
	#Play the tween
	tween.start()
	
	#Increment beat and fire off the timer again
	beat_count += 1
	handle_timer()
	
func get_winner():
	
	#What did each player choose?
	latest_player0_move = player_0.get_move()
	latest_player1_move = player_1.get_move()
	
	#Update the history
	global.player_0_moves.append(latest_player0_move)
	global.player_1_moves.append(latest_player1_move)
	
	#Did player 0 win?
	var player0_winner = MOVES_MODULE.Move_Wins(latest_player0_move, latest_player1_move)
	return player0_winner
	
func _play_sfx(sfx_name):
	#Get the player
	if sfx_node_dict.has(sfx_name):
		sfx_node_dict[sfx_name].play()
	