
extends Control


func _ready():
	pass


func _on_New_Game_pressed():
	get_node("/root/global").goto_scene("res://Scenes/GameMenu.tscn")


func _on_Load_Game_pressed():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load


func _on_Options_pressed():
	get_node("VBox").hide()
	get_node("OptionsContainer").show()


func _on_Slow_pressed():
	global.dialog_speed = 0.05


func _on_Medium_pressed():
	global.dialog_speed = 0.025


func _on_Fast_pressed():
	global.dialog_speed = 0.0125


func _on_Back_pressed():
	get_node("VBox").show()
	get_node("OptionsContainer").hide()
