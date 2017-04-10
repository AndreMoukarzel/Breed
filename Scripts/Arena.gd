
extends Control

var PageAmount = 8
var BoxColumns = 2

func _ready():
	print("Arena")




func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()

func _on_BattleGround_pressed():
	get_node("BattleMode/MonsterSelect/SelectBox").update_config(global.mon_depo, PageAmount, BoxColumns)
	get_node("BattleMode/MonsterSelect/SelectBox").generate_members()
	
	get_node("VBox").hide()
	get_node("BattleMode").show()

func _on_Back2_pressed():
	get_node("VBox").show()
	get_node("BattleMode").hide()
	get_node("BattleMode/MonsterSelect/Proceed").set_disabled(true)

func _on_Back3_pressed():
	get_node("BattleMode/MonsterSelect").show()
	get_node("BattleMode/RankSelect").hide()

func select_monster(monster, select_box):
	#test
	print("ID = ", monster.idn)
	
	get_node("BattleMode").selected_id = monster.idn
	# Enable continue button
	get_node("BattleMode/MonsterSelect/Proceed").set_disabled(false)

func _on_Proceed_pressed():
	get_node("BattleMode/MonsterSelect").hide()
	get_node("BattleMode/RankSelect").show()
