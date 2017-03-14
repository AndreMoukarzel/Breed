
extends Control


func _ready():
	get_node("SelectBox1").set_pos(Vector2(10, 40))
	get_node("SelectBox2").set_pos(Vector2(650, 40))


func update_boxes():
	get_node("SelectBox1").generate_members(get_parent().mon_depo, 8, 2)
	get_node("SelectBox2").generate_members(get_parent().mon_depo, 8, 2)

func _on_Back_pressed():
	self.hide()
	get_node("SelectBox1").clean_box()
	get_node("SelectBox2").clean_box()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()