extends Node

var PLAYER_0_COLOR = Color(0, 1, 0)
var PLAYER_1_COLOR = Color(0, 0, 1)
var LOSERS_COLOR = Color(0.5, 0.5, 0.5)
var DEBUG = false

var player_1_AI = false
var player_1_difficulty = false

var player_0_moves = []
var player_1_moves = []

func clear_history():
	player_0_moves = []
	player_1_moves = []