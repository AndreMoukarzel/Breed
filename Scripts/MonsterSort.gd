extends Button
	
var type
var pressed_once = false
	
func multi_sort(arg1, arg2):
	if (self.type == "Species"):
		if (arg1.species < arg2.species):
			return true
		else:
			return false
	if (self.type == "RSpecies"):
		if (arg1.species > arg2.species):
			return true
		else:
			return false
	elif (self.type == "Level"):
		if (arg1.level < arg2.level):
			return true
		else:
			return false
	elif (self.type == "RLevel"):
		if (arg1.level > arg2.level):
			return true
		else:
			return false
	
func _on_SortSpecies_pressed():
	if (pressed_once):
		pressed_once = false
		type = "RSpecies"
	else:
		pressed_once = true
		type = "Species"
	global.mon_depo.sort_custom(self, "multi_sort")
	
	get_parent().update_boxes_and_hide_display()


func _on_SortLevel_pressed():
	if (pressed_once):
		pressed_once = false
		type = "RLevel"
	else:
		pressed_once = true
		type = "Level"
	global.mon_depo.sort_custom(self, "multi_sort")

	get_parent().update_boxes_and_hide_display()
	
# Fazer por gender tambem