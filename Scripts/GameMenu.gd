
extends Control

var creature_scn = preload("res://Scenes/Monster.tscn")


class Monster:
	var name
	var species
	var color #will be vector
#	var ap_vec
	var level
	var xp
	var catal
	var STR
	var AGI
	var VIT
	var TEN
	var WIS
	var FER

	func _init(name, level, database):
		pass


func _ready():
	var creature = creature_scn.instance()
	
	creature.prepare("Mafagafo", Color(0.5, 0.5, 1))
	creature.set_pos(Vector2(220, 220))

	add_child(creature)


func _on_ToBreed_pressed():
	pass


func _on_ToTown_pressed():
	get_node("VBox").hide()
	get_node("FarmBackground").hide()
	get_node("Town").show()


func _on_ToArena_pressed():
	get_node("VBox").hide()
	get_node("FarmBackground").hide()
	get_node("Arena").show()
