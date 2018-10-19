extends Control

onready var grid = get_node("Grid")
onready var walls = get_node("Walls")

var grid_h_v_separation = 10

func _ready():
	create_board()

func create_board():
	var pkg = load("res://Scenes/Field.tscn")
	var x_pos = 0
	var y_pos = 1
	
	for i in range(pow(grid.columns, 2)):
		var new_field = pkg.instance()
		grid.add_child(new_field)
#		print("pos: ", x_pos,",", y_pos)
		new_field.field_pos = Vector2(x_pos % 9 + 1, y_pos)
		
		x_pos += 1
		if (i + 1) % 9 == 0:
			y_pos += 1
#		print("added")

func place_wall(field, field_side):
	var pkg = load("res://Scenes/Wall.tscn")
	var wall = pkg.instance()
	match field_side:
		field.field_side.TOP:
			wall.wall_pos = field.field_pos - Vector2(0, 1)
		field.field_side.RIGHT:
			wall.wall_pos = field.field_pos
			wall.rotation = 90
		field.field_side.BOTTOM:
			wall.wall_pos = field.field_pos
		field.field_side.LEFT:
			wall.wall_pos = field.field_pos - Vector2(1, 0)
			wall.rotation = 90
	
	if viable_wall_position(field, field_side, wall) == false:
		print("you cant place a wall here")
		return
	
	walls.add_child(wall)
	#the size and postition are calculated by the field width and height and the spacing
	wall.set_size(Vector2(field.get_size().x*2 + grid_h_v_separation, grid_h_v_separation))
	wall.set_position(Vector2((wall.wall_pos.x - 1)*(field.get_size().x + grid_h_v_separation), wall.wall_pos.y * field.get_size().y + (wall.wall_pos.y - 1) * grid_h_v_separation))
	wall.set_pivot_offset(wall.get_size()/2)
	wall.set_rotation_degrees(wall.rotation)
	
	
	
func viable_wall_position(field, field_side, wall):
	
	#is the wall on the field?
	if wall.wall_pos.x < 1 or wall.wall_pos.x > 8 or wall.wall_pos.x < 1 or wall.wall_pos.y > 8:
		return false
	
	#does the wall collide with any other wall?
	for w in walls.get_children():
		if wall.wall_pos == w.wall_pos:
			return false
		if field_side == field.field_side.TOP or field_side == field.field_side.BOTTOM:
			if (wall.wall_pos + Vector2(1, 0) == w.wall_pos or wall.wall_pos - Vector2(1, 0) == w.wall_pos) and w.rotation == 0:
				return false
		if field_side == field.field_side.RIGHT or field_side == field.field_side.LEFT:
			if (wall.wall_pos + Vector2(0, 1) == w.wall_pos or wall.wall_pos - Vector2(0, 1) == w.wall_pos) and w.rotation == 90:
				return false