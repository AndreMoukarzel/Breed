
extends Control

func _ready():
	print("Game Menu")
	#global.instace_dialog(self, "System", 0)
	
	get_node("HUD/Energy").set_max(global.energy)
	get_node("HUD/Energy").set_value(global.energy)
	get_node("HUD/Energy/EnergyLabel").set_text(str(global.energy))
	get_node("HUD/Quesha").set_text(str(global.quesha))

	#test
	g_monster.monster_generate(global.mon_depo, "Mafagafo", Color(-1, -1, -1), [6, 6, 6, 6, 6, 6], [0, 1], 30)
	g_monster.monster_generate(global.mon_depo, "nhi", Color(-1, -1, -1), [2, 2, 1, 0, 0, 0], [0, 13], 1)


####### BUTTON FUNCIONALITY #######

func _on_ToBreed_pressed():
	get_node("VBox").hide()
	get_node("Farmer").hide()
	get_node("FarmBackground").hide()
	get_node("Barn").show()

	get_node("Barn").update_boxes()
	get_node("Barn")._on_StorageBackground1_pressed()


func _on_ToSell_pressed():
	get_node("VBox").hide()
	get_node("Farmer").hide()
	get_node("FarmBackground").hide()

	get_node("Dumpster").show()


func _on_ToTown_pressed():
	get_node("VBox").hide()
	get_node("Farmer").hide()
	get_node("FarmBackground").hide()
	get_node("Town").show()


func _on_ToArena_pressed():
	get_node("VBox").hide()
	get_node("Farmer").hide()
	get_node("FarmBackground").hide()
	get_node("Arena").show()


func _on_ToSleep_pressed():
	global.handle_days(1)
	
	# Check on monster bonuses
	for monster in global.mon_depo:
		if (monster.catal_boosts.size() != 0):
			for num in range (0, monster.catal_boosts.size()):
				var stat_id = monster.catal_boosts[num][1]
				monster.stats[stat_id] -= monster.catal_boosts[num][0]
			monster.catal_boosts.clear()
