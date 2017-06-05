
extends Control

onready var mon_shop = get_node("MonsterShop")
onready var catal_shop = get_node("CatalShop")

var count = 0

func _ready():
	print("Town")
	get_node("Quesha").set_text(str(global.quesha))

################ BUTTON FUNCTIONALITY ################

func _on_ShopMonster_pressed():
	get_node("MonsterShop/SelectBox").update_config(mon_shop.shop_depo, mon_shop.PageAmount, mon_shop.BoxColumns)
	get_node("MonsterShop/SelectBox").generate_members()
	
	get_node("VBox").hide()
	mon_shop.show()


func _on_ShopCatalist_pressed():
	get_node("CatalShop/CatalystBox").catal_vec = catal_shop.shop_depo
	get_node("CatalShop/CatalystBox").generate_members()
	get_node("CatalShop/CatalystBox/Background").hide()
	get_node("CatalShop/CatalystBox/Return").set_pos(Vector2(-300, -300))
	
	get_node("VBox").hide()
	catal_shop.show()


func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()

	count = 0

################ OTHER FUNCTIONALITY ################

func select_monster(monster, select_box):
	get_node("MonsterShop/Display").display(monster)
	get_node("MonsterShop").selected_id = monster.idn
	get_node("MonsterShop/Buy").set_disabled(false)
	
	get_node("MonsterShop/Price").set_text(str("Price: " + str(calculate_price(monster))))


func select_catalyst(catal_index):
	get_node("CatalShop").selected_id = catal_index
	get_node("CatalShop/Buy").set_disabled(false)
	
#	get_node("MonsterShop/Price").set_text(str("Price: " + str(calculate_price(monster))))
	
	
func calculate_price(monster):
	var price = 0
	for stat in monster.stats:
		price += stat * 3
	return price
