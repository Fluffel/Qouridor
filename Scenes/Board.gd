extends Control

onready var grid = get_node("Grid")
onready var walls = get_node("Walls")
onready var players = get_node("Players")
onready var main = get_parent()

export var grid_h_v_separation = 10
export var board_dimension = 9 #MUST BE UNEQUAL


#signal added_players

func _ready():
	grid.connect("sort_children", self, "add_players", [], CONNECT_ONESHOT)
	grid.columns = board_dimension
	create_board()

func add_players():
	var pkg = load("res://Scenes/Player.tscn")
	
	for i in range(2):
		var player = pkg.instance()
		players.add_child(player)
		player.player_pos = Vector2(board_dimension/2, (board_dimension - 1 + i) % board_dimension) #field msut have an unequal number of fields (9 should be unchanged anyways)
		
#	emit_signal("added_players")
	
func create_board():
	var packed = load("res://Scenes/Field.tscn")
	for i in range(pow(grid.columns, 2)):
		var field = packed.instance()
		grid.add_child(field)
		field.field_pos = Vector2(i % 9, int(i/9))

func place_wall(field, field_side):
	print("field size: ", field.rect_size)
	var pkg = load("res://Scenes/Wall.tscn")
	var wall = pkg.instance()
	
	match field_side:
		FieldSide.TOP:
			wall.wall_pos = field.field_pos - Vector2(0, 1)
		FieldSide.RIGHT:
			wall.wall_pos = field.field_pos
			wall.rotation = 90
		FieldSide.BOTTOM:
			wall.wall_pos = field.field_pos
		FieldSide.LEFT:
			wall.wall_pos = field.field_pos - Vector2(1, 0)
			wall.rotation = 90
			
		
	if viable_wall_position(field, field_side, wall) == false:
		print("you cant place a wall here")
		return
		
	#place wall
	players.get_child(main.current_player.get_index()).place_wall(wall)

func viable_wall_position(field, field_side, wall):
	
	#is the wall on the field?
	if wall.wall_pos.x < 0 or wall.wall_pos.x > 7 or wall.wall_pos.y < 0 or wall.wall_pos.y > 7:
		return false
	
	#does the wall collide with any other wall?
	for w in walls.get_children():
		if wall.wall_pos == w.wall_pos:
			return false
		if field_side == FieldSide.TOP or field_side == FieldSide.BOTTOM:
			if (wall.wall_pos + Vector2(1, 0) == w.wall_pos or wall.wall_pos - Vector2(1, 0) == w.wall_pos) and w.rotation == 0:
				return false
		if field_side == FieldSide.RIGHT or field_side == FieldSide.LEFT:
			if (wall.wall_pos + Vector2(0, 1) == w.wall_pos or wall.wall_pos - Vector2(0, 1) == w.wall_pos) and w.rotation == 90:
				return false

func _on_Board_resized():
	for p in players.get_children():
		p.update_transformation()
	for w in walls.get_children():
		w.update_transformation()
