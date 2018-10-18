extends ColorRect

enum field_side{TOP, LEFT, BOTTOM, RIGHT}
var activated = false #if activated it will create a wall when right clicked 
var field_pos = Vector2() #the position will be from 1 to 9 into x and y direction where on step is one field

func _ready():
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")

func _mouse_entered():
	activated = true
	
func _mouse_exited():
	activated = false
	
func _input(event):
	
	if activated:
#		print(event)
		if event is InputEventMouseButton:
			if event.get_button_index() == BUTTON_LEFT and event.is_pressed():
				print("yesman")
				print("you clicked on the ", get_field_side(), "of the field")
				print("field pos: ", field_pos)
		
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
		return field_side.TOP
	elif mouse_y >= y - (int(x + indicator*mouse_x) % int(x)) * (y/x):
		return field_side.BOTTOM
	elif mouse_x < x/2 and y - mouse_x * (y/x) > mouse_y and mouse_y > mouse_x * (y/x):
		return field_side.LEFT
	elif mouse_x > x/2 and y - mouse_x * (y/x) < mouse_y and mouse_y < mouse_x * (y/x):
		return field_side.RIGHT