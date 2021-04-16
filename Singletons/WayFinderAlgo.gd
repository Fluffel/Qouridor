extends Node

class_name WayFinder

var marked_field_sides = {
	ActionType.Top: false,
	ActionType.Right: false,
	ActionType.Bottom: false,
	ActionType.Left: false
}
var marked_fields = Dictionary()
var completed_fields
var direction = {
	ActionType.TOP: [0,-1],
	ActionType.Right: [1,0],
	ActionType.Bottom: [0,1],
	ActionType.Left: [-1.0]
}

onready var board = get_node("/root/Main/Board")

func start(player):
	marked_fields[player.pos] = marked_field_sides.duplicate()
	do_algo()
	
func do_algo():
	if marked
