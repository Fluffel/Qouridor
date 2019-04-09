#extends CenterContainer
extends Control

onready var players = $Board/Players

var current_player setget _set_current_player
#player 0 is the 0th (first) child of players in the board control. 1 the second... this variable handles turns


func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_up"):
			current_player.move(Move.UP)
		if event.is_action_pressed("ui_right"):
			current_player.move(Move.RIGHT)
		if event.is_action_pressed("ui_down"):
			current_player.move(Move.DOWN)
		if event.is_action_pressed("ui_left"):
			current_player.move(Move.LEFT)
			
func _set_current_player(new_player_index):
	current_player = players.get_child(new_player_index)
#func _get_current_player():
#	return current_player.get_index()

func change_turn():
	self.current_player = (current_player.get_index() + 1) % 2
