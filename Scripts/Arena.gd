
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


func _on_Race_pressed():
	get_node("RaceMode/MonsterSelect/SelectBox").update_config(global.mon_depo, PageAmount, BoxColumns)
	get_node("RaceMode/MonsterSelect/SelectBox").generate_members()
	
	get_node("VBox").hide()
	get_node("RaceMode").show()


func _on_Back2_pressed():
	get_node("VBox").show()
	get_node("BattleMode").hide()
	get_node("BattleMode/MonsterSelect/BattleDisplay").hide()
	get_node("BattleMode/MonsterSelect/Proceed").set_disabled(true)


func _on_Back3_pressed():
	get_node("BattleMode/MonsterSelect").show()
	get_node("BattleMode/RankSelect").hide()


func _on_Back4_pressed():
	get_node("VBox").show()
	get_node("RaceMode").hide()
	get_node("RaceMode/MonsterSelect/Proceed2").set_disabled(true)


func _on_Back5_pressed():
	get_node("RaceMode/MonsterSelect").show()
	get_node("RaceMode/RankSelect").hide()


func _on_Proceed_pressed():
	get_node("BattleMode/MonsterSelect").hide()
	get_node("BattleMode/RankSelect").show()


func _on_Proceed2_pressed():
	get_node("RaceMode/MonsterSelect").hide()
	get_node("RaceMode/RankSelect").show()


func select_monster(monster, select_box):
	#test
	print("ID = ", monster.idn)
	
#	if (get_node("BattleMode").is_visible()):
#		get_node("BattleMode").selected_id = monster.idn
#		# Enable continue button
#		get_node("BattleMode/MonsterSelect/Proceed").set_disabled(false)
#	elif (get_node("RaceMode").is_visible()):
	get_node("RaceMode").selected_id = monster.idn
	# Enable continue button
	get_node("RaceMode/MonsterSelect/Proceed2").set_disabled(false)