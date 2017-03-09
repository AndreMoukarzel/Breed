
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	print("Arena")




func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()