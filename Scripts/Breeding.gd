
extends Control

export var BoxColumns = 2
export var PageAmount = 8

onready var Sbox1 = get_node("Storage1/SelectBox")
onready var Sbox2 = get_node("Storage2/SelectBox")


func _ready():
	Sbox1.set_pos(Vector2(10, 40))
	Sbox2.set_pos(Vector2(650, 40))


func update_boxes():
	Sbox1.update_config(get_parent().mon_depo, PageAmount, BoxColumns)
	Sbox1.generate_members()
	Sbox2.update_config(get_parent().mon_depo, PageAmount, BoxColumns)
	Sbox2.generate_members()


func _on_Breed_pressed():
	Sbox1.clean_box()
	Sbox2.clean_box()
	update_boxes()


func _on_Back_pressed():
	self.hide()
	get_node("SelectBox1").clean_box()
	get_node("SelectBox2").clean_box()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()
