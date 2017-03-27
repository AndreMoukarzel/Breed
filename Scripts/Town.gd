
extends Control

onready var mon_shop = get_node("MonsterShop")

var count = 0

func _ready():
	print("Town")

################ BUTTON FUNCTIONALITY ################

func _on_ShopMonster_pressed():
	get_node("MonsterShop/SelectBox").update_config(mon_shop.shop_depo, mon_shop.PageAmount, mon_shop.BoxColumns)
	get_node("MonsterShop/SelectBox").generate_members()
	
	get_node("VBox").hide()
	mon_shop.show()
	

func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()

	count = 0

################ OTHER FUNCTIONALITY ################

func select_monster(monster, select_box):
	get_node("MonsterShop/Price").set_text(str("Price: " + str(calculate_price(monster))))
	
func calculate_price(monster):
	var price = 0
	for stat in monster.stats:
		price += stat * 3
	return price