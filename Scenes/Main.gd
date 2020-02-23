#extends CenterContainer
extends Control

onready var players = $Board/Players
var action_list

var current_player setget _set_current_player
#player 0 is the 0th (first) child of players in the board control. 1 the second... this variable handles turns


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
#	return current_player.get_index()			!!This causes inconsistency. Don't delete until I found a clear solution

func change_turn(action_type, position):
	add_action_to_list(action_type, position)
	self.current_player = (current_player.get_index() + 1) % 2

func add_action_to_list(action_type, pos):
	var action_pckg = load("res://Scenes/Action.tscn")
	var action = action_pckg.instance()
	
	action.type = action_type
	action.pos = pos
	action.player = current_player.get_index()
	
	action_list.append(action)
	
