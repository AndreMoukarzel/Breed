extends VBoxContainer
	
var type = ""


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
	if (type == "Species"):
		type = "RSpecies"
	else:
		type = "Species"
	global.mon_depo.sort_custom(self, "multi_sort")
	
	get_parent().update_boxes_and_hide_display()


func _on_SortLevel_pressed():
	if (type == "Level"):
		type = "RLevel"
	else:
		type = "Level"
	global.mon_depo.sort_custom(self, "multi_sort")

	get_parent().update_boxes_and_hide_display()


func _on_SortGender_pressed():
	if (type == "Gender"):
		type = "RGender"
	else:
		type = "Gender"
	global.mon_depo.sort_custom(self, "multi_sort")

	get_parent().update_boxes_and_hide_display()