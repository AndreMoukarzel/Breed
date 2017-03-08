
extends Control

var creature_scn = preload("res://Scenes/Monster.tscn")

var mon_depo = []

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

	func _init(name, species, color):
		self.name = name
		self.species = species
		self.color = color


func _ready():
	monster_generate("", "nhi", Color(-1, -1, -1))

############  BUTTONS  ############

func _on_ToBreed_pressed():
	monster_generate("", "nhi", Color(-1, -1, -1))

	for mon in mon_depo:
		print(mon.name)


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
func monster_generate(name, species, color):
	var nick
	var monster
	var info # [species, color]

	info = monster_sprite(species, color, Vector2(220, 220))

	if( name == "" ):
		var count = 1
		for mon in mon_depo:
			if( mon.species == info[0] ):
				count += 1
		nick = str(info[0], count)
	monster = Monster.new(nick, info[0], info[1])

	mon_depo.append(monster)


func monster_sprite(species, color, pos):
	var creature = creature_scn.instance()
	var id = creature.get_id(species)
	var col = color

	randomize()
	if( id == -1 ):
		id = randi() % creature.pos_database.size()

	if( col == Color( -1, -1, -1) ):
		col = Color( rand_range(0.1, 1), rand_range(0.1, 1), rand_range(0.1, 1))

	creature.prepare(id, col)
	creature.set_pos(pos)

	add_child(creature)

	return [creature.get_species(id), col]