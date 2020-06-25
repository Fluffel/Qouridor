extends ColorRect

var pos
var type
var player

func _ready():
	if type == ActionType.move:
		color = Color(250,0,0)
	else: 
		color = Color(0,250,250)
