extends ColorRect


onready var board = get_node("/root/Main/Board")

var activated = false #if activated it will create a wall when right clicked 
var field_pos = Vector2() #the position will be from 1 to 9 into x and y direction where on step is one field
var mouse_field_side


signal field_side_changed(field, field_side)


func _ready():
	set_process(activated)
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")

func _mouse_entered():
	print("mouse entered")
	activated = true
	emit_signal("field_side_changed", self, get_field_side())
	set_process(activated)
	
func _mouse_exited():
	activated = false
	set_process(activated)
func _input(event):
	
	if activated:
#		print(event)
		if event is InputEventMouseButton:
			if event.get_button_index() == BUTTON_LEFT and event.is_pressed():
#				print("field pos: ", field_pos)
#				print("is wall on sie: ", is_wall_on_side(get_field_side()))
				board.place_wall(self, get_field_side())
		
func get_field_side():
	#this function will check in which triangle of the color rect the mouse is located. The triangles would be obtained by drawing the diagonals.
	var x = get_size().x
	var y = get_size().y
	var mouse_x = get_local_mouse_position().x
	var mouse_y = get_local_mouse_position().y
	var indicator #like in an indicator function. used for triangle at the bottom and top
	if mouse_x <= x/2:
		indicator = 1
	else:
		indicator = -1
	
	#The following if statements check for each triangle, whether the y and x coordinates of the mouse are coordinates that could be in that triangle.
	if mouse_y <= (int(x + indicator*mouse_x) % int(x)) * (y/x):
		return FieldSide.TOP
	elif mouse_x > x/2 and y - mouse_x * (y/x) < mouse_y and mouse_y < mouse_x * (y/x):
		return FieldSide.RIGHT
	elif mouse_y >= y - (int(x + indicator*mouse_x) % int(x)) * (y/x):
		return FieldSide.BOTTOM
	elif mouse_x < x/2 and y - mouse_x * (y/x) > mouse_y and mouse_y > mouse_x * (y/x):
		return FieldSide.LEFT
		
func is_wall_on_side(field_side):
	match field_side:
		FieldSide.TOP:
			for w in board.walls.get_children():
#				print("wall rot: ",w.rotation)
				if w.rotation == 0:
#					print("wall pos: ",w.wall_pos)
					if w.wall_pos == field_pos - Vector2(0, 1) or w.wall_pos == field_pos - Vector2(1, 1):
						return true
		FieldSide.RIGHT:
			for w in board.walls.get_children():
				if w.rotation == 90:
					if w.wall_pos == field_pos - Vector2(0, 0) or w.wall_pos == field_pos - Vector2(0, 1):
						return true
		FieldSide.BOTTOM:
			for w in board.walls.get_children():
				if w.rotation == 0:
					if w.wall_pos == field_pos - Vector2(0, 0) or w.wall_pos == field_pos - Vector2(1, 0):
						return true
		FieldSide.LEFT:	
			for w in board.walls.get_children():
				if w.rotation == 90:
					if w.wall_pos == field_pos - Vector2(1, 0) or w.wall_pos == field_pos - Vector2(1, 1):
						return true

func _process(_delta):
	var new_side = get_field_side()
	if mouse_field_side != new_side:
		print("changed field: ", new_side, ", ", mouse_field_side)
		mouse_field_side = new_side
		emit_signal("field_side_changed", self, mouse_field_side)
