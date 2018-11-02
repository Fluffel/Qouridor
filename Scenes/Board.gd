extends Control

onready var grid = get_node("Grid")
onready var walls = get_node("Walls")
onready var players = get_node("Players")

var grid_h_v_separation = 10

signal added_players

func _ready():
	create_board()
	grid.connect("sort_children", self, "add_players", [], CONNECT_ONESHOT)

func add_players():
	var packed = load("res://Scenes/Player.tscn")
	var field_example = grid.get_child(0)
	
	for i in range(2):
		var player = packed.instance()
		print("added_player", i)
		players.add_child(player)
		player.set_size(field_example.get_size())
		player.board_pos = Vector2(int(grid.columns/2 + 1), ((8 + i) % 9))
		player.set_position(Vector2((grid.columns/2)*field_example.get_size().x + int(grid.columns/2) * grid_h_v_separation, (((8 + i) % 9) + 1/2) * field_example.get_size().y + ((8 + i) % 9) * grid_h_v_separation))

#		print("pos", player.get_position())
#		print("field size", grid.get_child(0).rect_size)
		emit_signal("added_players")
	
func create_board():
	var packed = load("res://Scenes/Field.tscn")

	
	for i in range(pow(grid.columns, 2)):
		var field = packed.instance()
		grid.add_child(field)
#		print("pos: ", x_pos,",", y_pos)
		field.field_pos = Vector2(i % 9, int(i/9))

#		print("added")

func place_wall(field, field_side):
	print("field size: ", field.rect_size)
#	print("field in grid: ", grid.get_child(0).rect_size)
	var packed = load("res://Scenes/Wall.tscn")
	var wall = packed.instance()
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
	wall.set_position(Vector2((wall.wall_pos.x)*(field.get_size().x + grid_h_v_separation), (wall.wall_pos.y + 1) * field.get_size().y + (wall.wall_pos.y) * grid_h_v_separation))
	wall.set_pivot_offset(wall.get_size()/2)
	wall.set_rotation_degrees(wall.rotation)
	
	
	
func viable_wall_position(field, field_side, wall):
	
	#is the wall on the field?
	if wall.wall_pos.x < 0 or wall.wall_pos.x > 7 or wall.wall_pos.y < 0 or wall.wall_pos.y > 7:
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