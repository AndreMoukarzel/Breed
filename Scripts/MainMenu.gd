
extends Control


func _ready():
	pass


func _on_New_Game_pressed():
	get_node("/root/global").goto_scene("res://Scenes/GameMenu.tscn")


func _on_Load_Game_pressed():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
