
extends Control

onready var mon_shop = get_node("MonsterShop")
onready var catal_shop = get_node("CatalShop")

var count = 0
var cat = []

func _ready():
	print("Town")

################ BUTTON FUNCTIONALITY ################

func _on_ShopMonster_pressed():
	# The == 0 part is for testing purposes only
	if (global.generate_shop):
		get_node("MonsterShop").generate_shop()
		global.generate_shop = false
	
	get_node("MonsterShop/SelectBox").update_config(mon_shop.shop_depo, mon_shop.PageAmount, mon_shop.BoxColumns)
	get_node("MonsterShop/SelectBox").generate_members()
	
	get_node("VBox").hide()
	mon_shop.show()


func _on_ShopCatalist_pressed():
	var cat_box = get_node("CatalShop/CatalystBox")
	cat_box.catal_vec = catal_shop.shop_depo
	cat_box.generate_members()
	get_node("CatalShop/CatalystBox/Background").hide()
	get_node("CatalShop/CatalystBox/Return").set_pos(Vector2(-300, -300))
	get_node("CatalShop/CatalystBox/AmountChooser").update_display(catal_shop.shop_depo, cat)
	
	get_node("VBox").hide()
	catal_shop.show()


func _on_Back_pressed():
	self.hide()
	get_parent().get_node("Buttons").show()
	get_parent().get_node("Farmer").show()
	get_parent().get_node("FarmBackground").show()

	count = 0

################ OTHER FUNCTIONALITY ################

func select_monster(monster, select_box):
	get_node("MonsterShop/PriceBackground").show()
	get_node("MonsterShop/Price").show()
	get_node("MonsterShop/KeshaIcon").show()
	get_node("MonsterShop/Display").display(monster)
	get_node("MonsterShop").selected_id = monster.idn
	get_node("MonsterShop/Buy").set_disabled(false)
	
	get_node("MonsterShop/Price").set_text(str("Price: " + str(calculate_price(monster))))


func select_catalyst( catalyst ):
	get_node("CatalShop/Buy").set_disabled(false)
	
	var index = cat.find(catalyst)
	if (index != -1): # same catalyst selected again = deselected
		cat.remove(index)
	else:
		cat.append(catalyst)

	if (cat.empty()):
		get_node("CatalShop/Buy").hide()
		get_node("CatalShop/CatalystBox/AmountChooser").hide()
	else:
		get_node("CatalShop/Buy").show()
		get_node("CatalShop/CatalystBox/AmountChooser").show()
		get_node("CatalShop/CatalystBox/AmountChooser").update_display(catal_shop.shop_depo, cat)
#	get_node("MonsterShop/Price").set_text(str("Price: " + str(calculate_price(monster))))
	
	
func calculate_price(monster):
	var price = 0
	for stat in monster.stats:
		price += stat * 3
	return price
