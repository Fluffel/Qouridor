extends Control

onready var grid = get_node("Grid")

func _ready():
	create_board()


func create_board():
	var pkg = load("res://Scenes/Field.tscn")
	var x_pos = 1
	var y_pos = 1
	
	for i in range(pow(grid.columns, 2)):
		var new_field = pkg.instance()
		grid.add_child(new_field)
#		print("pos: ", x_pos,",", y_pos)
		new_field.field_pos = Vector2(x_pos % 9, y_pos)
		
		x_pos += 1
		if (i + 1) % 9 == 0:
			y_pos += 1
#		print("added")

func place_wall(field_pos, field_side):
	var pkg = load("res://Scenes/Wall.tscn")
	