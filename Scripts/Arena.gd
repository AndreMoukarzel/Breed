
extends Control

var PageAmount = 8
var BoxColumns = 2

func _ready():
	print("Arena")


func _on_Back_pressed():
	self.hide()
	get_parent().get_node("Buttons").show()
	get_parent().get_node("Farmer").show()
	get_parent().get_node("FarmBackground").show()


func _on_BattleGround_pressed():
	get_node("BattleMode/MonsterSelect/SelectBox").update_config(global.mon_depo, PageAmount, BoxColumns)
	get_node("BattleMode/MonsterSelect/SelectBox").generate_members()
	
	get_node("VBox").hide()
	get_node("BattleMode").show()
	
	for num in range (1, global.battle_progress + 1):
		get_node(str("BattleMode/MonsterSelect/Rank", num)).show()


func _on_Race_pressed():
	get_node("RaceMode/MonsterSelect/SelectBox").update_config(global.mon_depo, PageAmount, BoxColumns)
	get_node("RaceMode/MonsterSelect/SelectBox").generate_members()
	
	get_node("VBox").hide()
	get_node("RaceMode").show()
	
	for num in range (1, global.battle_progress + 1):
		get_node(str("RaceMode/MonsterSelect/Rank", num)).show()


func _on_BackBattle_pressed():
	get_node("BattleMode").mon = null
	get_node("VBox").show()
	get_node("BattleMode").hide()
	get_node("BattleMode/MonsterSelect/BattleDisplay").hide()


func _on_BackRace_pressed():
	get_node("RaceMode").mon = null
	get_node("VBox").show()
	get_node("RaceMode").hide()
	get_node("RaceMode/MonsterSelect/RaceDisplay").hide()