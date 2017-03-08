
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()
