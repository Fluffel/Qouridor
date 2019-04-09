extends ColorRect

onready var main = get_node("/root/Main")
onready var board = get_node("/root/Main/Board")

var wall_pos = Vector2()
var rotation = 0 #0 is horizontal

# Called when the node enters the scene tree for the first time.
func _ready():
	update_transformation()


#the size and postition are calculated by the field width and height and the spacing
func update_transformation():
	var field_example = board.grid.get_child(0)
	set_size(Vector2(field_example.get_size().x * 2 + board.grid_h_v_separation, board.grid_h_v_separation))
	set_position(Vector2(wall_pos.x * (field_example.get_size().x + board.grid_h_v_separation), (wall_pos.y + 1) * field_example.get_size().y + (wall_pos.y) * board.grid_h_v_separation))
	set_pivot_offset(get_size()/2)
	set_rotation_degrees(rotation)