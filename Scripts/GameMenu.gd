
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
	generate_creature( "nhi", Color(-1, -1, -1))

############  BUTTONS  ############

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


##########  FUNCTIONALITY  ##########

# If species term does not correspond to any species, randomize species
# If Color(-1, -1, -1), randomize color
func generate_creature(species, color):
	var creature = creature_scn.instance()
	var id = creature.get_id(species)
	var col = color

	randomize()
	if( id == -1 ):
		id = randi() % creature.pos_database.size()

	if( col == Color( -1, -1, -1) ):
		col = Color( rand_range(0.1, 1), rand_range(0.1, 1), rand_range(0.1, 1))

	creature.prepare(id, col)
	creature.set_pos(Vector2(220, 220))

	add_child(creature)