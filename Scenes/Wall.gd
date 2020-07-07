extends ColorRect

var board

var wall_pos = Vector2() setget change_pos
var rotation = 0 setget change_rot#0 is horizontal

# Called when the node enters the scene tree for the first time.
func _ready():
	board = get_node("/root/Main/Board")

func change_pos(pos):
	wall_pos = pos
	update_transformation()
	
func change_rot(rot):
	rotation = rot
	update_rotation()
	
func update_rotation():
	print("update")
	set_pivot_offset(get_size()/2)
	set_rotation_degrees(rotation)
	
#the size and postition are calculated by the field width and height and the spacing
func update_transformation():
	var field_example = board.grid.get_child(0)
	set_size(Vector2(field_example.get_size().x * 2 + board.grid_h_v_separation, board.grid_h_v_separation))
	set_position(Vector2(wall_pos.x * (field_example.get_size().x + board.grid_h_v_separation), (wall_pos.y + 1) * field_example.get_size().y + (wall_pos.y) * board.grid_h_v_separation))
	
