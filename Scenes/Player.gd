extends ColorRect

onready var board = get_parent().get_parent()
enum moves{UP, RIGHT, DOWN, LEFT}

var board_pos

export var amount_walls = 10
func _ready():
	pass

func move(direction):
	var field_example = board.get_node("Grid").get_child(0)
	var x_change = Vector2(field_example.rect_size.x + board.grid_h_v_separation, 0)
	var y_change = Vector2(0,field_example.rect_size.y + board.grid_h_v_separation)
	match direction:
		moves.UP:
			board_pos += Vector2(0,-1)
			set_position(get_position() - y_change)
			print("go up")
		moves.RIGHT:
			board_pos += Vector2(1,0)
			set_position(get_position() + x_change)
			print("go right")
		moves.DOWN:
			board_pos += Vector2(0,1)
			set_position(get_position() + y_change)
			print("go down")
		moves.LEFT:
			board_pos += Vector2(-1,0)
			set_position(get_position() - x_change)
			print("go left")
	print("player pos: ", board_pos)
