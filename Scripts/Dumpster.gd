
extends Control

var screen = null

var mon = null #selected monster
var cat = -1 #selected catalyst

func _ready():
	get_node("Boxes/Mons").update_config(global.mon_depo, 20, 5)

	get_node("Boxes/Mons/BackMon").set_pos(Vector2(390, 500))
	get_node("Boxes/Catals/BackCatal").set_pos(Vector2(390, 500))


func generate_boxes():
	get_node("Boxes/Mons").generate_members()
	get_node("Boxes/Catals").generate_members()


func select_monster( monster, select_box ):
	mon = monster
	get_node("Boxes/Sell").show()

####### BUTTON FUNCIONALITY #######

func _on_SellMonster_pressed():
	get_node("VBox").hide()
	get_node("Boxes/Mons").show()
	screen = "monster"


func _on_SellCatal_pressed():
	get_node("VBox").hide()
	get_node("Boxes/Catals").show()
	screen = "catalyst"


func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()
	screen = null
	mon = null
	cat = -1


func _on_BackMon_pressed():
	get_node("Boxes/Mons").hide()
	get_node("Boxes/Sell").hide()
	get_node("VBox").show()
	mon = null


func _on_BackCatal_pressed():
	get_node("Boxes/Catals").hide()
	get_node("Boxes/Sell").hide()
	get_node("VBox").show()
	cat = -1


func _on_Sell_pressed():
	if (screen == "monster"):
	
	elif (screen == "catalyst"):
		# gib mony
		re