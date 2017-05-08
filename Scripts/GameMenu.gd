
extends Control

func _ready():
	print("Game Menu")
	get_node("HUD/Energy").set_max(global.energy)
	get_node("HUD/Energy").set_value(global.energy)
	get_node("HUD/Energy/EnergyLabel").set_text(str(global.energy))

	#test
	g_monster.monster_generate(global.mon_depo, "Mafagafo", Color(-1, -1, -1), [], [6, 6, 6, 6, 6, 6], [0], 10)
	g_monster.monster_generate(global.mon_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], [8], 10)


####### BUTTON FUNCIONALITY #######

func _on_ToBreed_pressed():
	get_node("VBox").hide()
	get_node("FarmBackground").hide()
	get_node("Barn").show()

	get_node("Barn").update_boxes()


func _on_ToTown_pressed():
	get_node("VBox").hide()
	get_node("FarmBackground").hide()
	get_node("Town").show()


func _on_ToArena_pressed():
	get_node("VBox").hide()
	get_node("FarmBackground").hide()
	get_node("Arena").show()


func _on_ToSleep_pressed():
	global.handle_days(1)
