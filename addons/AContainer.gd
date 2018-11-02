tool
extends Container
class_name AContainer

export var aspect = 1.0 setget update_aspect
export var centered = true setget update_centered
func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		for c in get_children():
			var container_aspect = rect_size.aspect()
			var size = Vector2(0,0)
			var ofs = Vector2(0,0)
			if container_aspect < aspect:
				size.x = rect_size.x
				size.y = rect_size.x / aspect
				if centered:
					ofs.y = (rect_size.y - size.y) * 0.5
			else:
				size.x = rect_size.y * aspect
				size.y = rect_size.y
				if centered:
					ofs.x = (rect_size.x - size.x) / 2.0 #hoffe das findest du lustig... und hoffe du weist was ich meine hint: 2.0
			
				
			fit_child_in_rect(c,Rect2(ofs, size))
			
func update_aspect(new_val):
	aspect = new_val
	queue_sort()
func update_centered(new_val):
	centered = new_val
	queue_sort()