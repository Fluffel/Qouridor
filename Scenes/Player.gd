extends ColorRect

var player_pos setget set_player_pos

onready var main = get_node("/root/Main")
onready var board = get_node("/root/Main/Board")

var board_pos

export var amount_walls = 10

func _ready():
	if main.current_player == null:
		main.current_player = 0
	color = Color(randi())

func place_wall(wall):
	board.walls.add_child(wall)
	amount_walls -= 1
	print("p: ", get_index(), " ", "amount walls left: ", amount_walls)
	main.change_turn()
	
func move(direction):
	var new_location = do_move(direction, self.player_pos)
	
	#check whether the new location is inside the field
	if not ((new_location.x >= 0 and new_location.x < board.board_dimension) and (new_location.y >= 0 and new_location.y < board.board_dimension)):
		print("you cant move outside the boundaries")
		return
	
	#check whether move is crossing a wall
	if on_which_field().is_wall_on_side(direction):
		print("you cannot move through walls")
		return
	#jump over opponent when landing on him
	if new_location == get_opponent().player_pos:
		new_location = do_move(direction, new_location)
	self.player_pos = new_location
	main.change_turn()
	
func do_move(direction, loc):
	match direction:
		Move.UP:
			loc = loc + Vector2(0, -1)
		Move.RIGHT:
			loc = loc + Vector2(1, 0)
		Move.DOWN:
			loc = loc + Vector2(0, 1)
		Move.LEFT:
			loc = loc + Vector2(-1, 0)
	return loc
	
func on_which_field():
	for f in board.grid.get_children():
		if f.field_pos == player_pos:
			return f
			
func set_player_pos(new_pos):
	player_pos = new_pos
	update_transformation()
	

func update_transformation():
	var field_example = board.grid.get_child(0)
	set_size(field_example.get_size())
	set_position(Vector2(self.player_pos.x * field_example.get_size().x + self.player_pos.x * board.grid_h_v_separation, self.player_pos.y * field_example.get_size().y + self.player_pos.y * board.grid_h_v_separation))

func get_opponent():
	return board.players.get_child((get_index() + 1) % 2)
