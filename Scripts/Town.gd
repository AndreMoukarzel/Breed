
extends Control

onready var mon_shop = get_node("MonsterShop")

var count = 0

func _ready():
	print("Town")

################ BUTTON FUNCTIONALITY ################

func _on_ShopMonster_pressed():
	get_node("MonsterShop/SelectBox").update_config(mon_shop.shop_depo, mon_shop.PageAmount, mon_shop.BoxColumns)
	get_node("MonsterShop/SelectBox").generate_members()

func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()

	count = 0

################ OTHER FUNCTIONALITY ################

func select_monster(monster, select_box):
	pass