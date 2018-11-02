extends CenterContainer

onready var board = $Board
onready var players = $Board/Players
var current_player#player 0 is the 0th (first) child of players in the board control. 1 the second... this variable handles turns


func _ready():
	board.connect("added_players", self, "update_player", [], CONNECT_ONESHOT)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_up"):
			print("inp")
			current_player.move(current_player.moves.UP)
		if event.is_action_pressed("ui_right"):
			current_player.move(current_player.moves.RIGHT)
		if event.is_action_pressed("ui_down"):
			current_player.move(current_player.moves.DOWN)
		if event.is_action_pressed("ui_left"):
			current_player.move(current_player.moves.LEFT)
				
func update_player():
	if current_player == players.get_child(0):
		current_player = players.get_child(0)
	else:
		current_player = players.get_child(0)