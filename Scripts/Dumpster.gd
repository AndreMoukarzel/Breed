
extends Control

var screen = null

var mon = null #selected monster
var cat = -1 #selected catalyst

func _ready():
	get_node("Boxes/Mons").update_config(global.mon_depo, 20, 5)

	get_node("Boxes/Mons/BackMon").set_pos(Vector2(390, 500))
	get_node("Boxes/Catals/BackCatal").set_pos(Vector2(390, 500))
	get_node("Boxes/Catals/Background").hide()


func select_monster( monster, select_box ):
	mon = monster
	get_node("Boxes/Sell").show()


func select_catalyst( catalyst ):
	cat = catalyst
	get_node("Boxes/Sell").show()


####### BUTTON FUNCIONALITY #######

func _on_SellMonster_pressed():
	get_node("VBox").hide()
	get_node("Boxes/Mons").generate_members()
	get_node("Boxes/Mons").show()
	screen = "monster"


func _on_SellCatal_pressed():
	get_node("VBox").hide()
	get_node("Boxes/Catals").generate_members()
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
	get_node("Boxes/Mons").clear_box()


func _on_BackCatal_pressed():
	get_node("Boxes/Catals").hide()
	get_node("Boxes/Sell").hide()
	get_node("VBox").show()
	cat = -1
	get_node("Boxes/Catals").clear_box()


func _on_Sell_pressed():
	if (screen == "monster"):
		sell_monster()
	elif (screen == "catalyst"):
		sell_catalyst()


func sell_monster():
	var price = 0
	for stat in mon.stats:
		price += stat * 3
	price /= 2

	gib_money(price)

	var i = 0
	for monster in global.mon_depo:
		if (monster.idn == mon.idn):
			global.mon_depo.remove(i)
			break
		i += 1
	get_node("Boxes/Mons").clear_box()
	get_node("Boxes/Mons").generate_members()


func sell_catalyst():
	gib_money(1)

	var amount = 1
	global.catal_depo[cat][1] -= amount
	if (global.catal_depo[cat][1] == 0):
		global.catal_depo.remove(cat)
	get_node("Boxes/Catals").clear_box()
	get_node("Boxes/Catals").generate_members()


func gib_money(mony):
	global.quesha += mony