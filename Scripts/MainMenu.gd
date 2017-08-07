
extends Control


func _ready():
	position(OS.get_window_size())
	# Loads options configuration
	load_config()


func position(size):
	get_node("VBox").set_size(size)
	get_node("OptionsContainer").set_size(size - Vector2(0, 20))
	get_node("OptionsContainer").set_pos(Vector2(0, 20))
	get_node("OptionsContainer/TextSpeedContainer").set_size(Vector2(size.x, 100))


func _on_New_Game_pressed():
	get_node("/root/global").goto_scene("res://Scenes/GameMenu.tscn")


func _on_Load_Game_pressed():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load


func _on_Options_pressed():
	get_node("VBox").hide()
	get_node("OptionsContainer").show()
	
	print (global.dialog_speed)
	
	if (global.dialog_speed >= 0.04):
		get_node("OptionsContainer/TextSpeedContainer/Slow").set_disabled(true)
	elif (global.dialog_speed >= 0.015):
		get_node("OptionsContainer/TextSpeedContainer/Medium").set_disabled(true)
	elif (global.dialog_speed >= 0.0115):
		get_node("OptionsContainer/TextSpeedContainer/Fast").set_disabled(true)


func _on_Slow_pressed():
	global.dialog_speed = 0.05
	
	for node in get_node("OptionsContainer/TextSpeedContainer").get_children():
		node.set_disabled(false)
	get_node("OptionsContainer/TextSpeedContainer/Slow").set_disabled(true)
	
	save_config()

func _on_Medium_pressed():
	global.dialog_speed = 0.025
	
	for node in get_node("OptionsContainer/TextSpeedContainer").get_children():
		node.set_disabled(false)
	get_node("OptionsContainer/TextSpeedContainer/Medium").set_disabled(true)
	
	save_config()

func _on_Fast_pressed():
	global.dialog_speed = 0.0125
	
	for node in get_node("OptionsContainer/TextSpeedContainer").get_children():
		node.set_disabled(false)
	get_node("OptionsContainer/TextSpeedContainer/Fast").set_disabled(true)
	
	save_config()
	
func save_config():
	# Begin Dictionary
	
	var configdict = {
		
		dialog_speed = global.dialog_speed
		
		}
	
	var config_save = File.new()
	config_save.open("user://configsave.save", File.WRITE)
	config_save.store_line(configdict.to_json())
	config_save.close()
	
func load_config():
	var config_save = File.new()
	if !config_save.file_exists("user://configsave.save"):
		#test
		print ("No config found.")
		return #Error!  We don't have a save to load

	config_save.open("user://configsave.save", File.READ)
	var config_data = {}
	config_data.parse_json(config_save.get_as_text())
	config_save.close()
	
	global.dialog_speed = config_data.dialog_speed


func _on_Back_pressed():
	get_node("VBox").show()
	get_node("OptionsContainer").hide()
