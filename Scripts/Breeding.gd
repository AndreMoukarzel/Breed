
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("SelectBox1").generate_members(get_parent().mon_depo, 15, 3, 100)
	get_node("SelectBox1").set_pos(Vector2(10, 10))
	get_node("SelectBox2").generate_members(get_parent().mon_depo, 15, 3, 100)
	get_node("SelectBox2").set_pos(Vector2(700, 10))


func _on_Back_pressed():
	self.hide()
	get_node("SelectBox1").clean_box()
	get_node("SelectBox2").clean_box()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()