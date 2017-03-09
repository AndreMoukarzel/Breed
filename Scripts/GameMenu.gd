
extends Control

var creature_scn = preload("res://Scenes/Monster.tscn")

var mon_depo = []

class Monster:
	var name
	var species
	var color #will be vector
	var ap_vec #apendices
	var level
	var xp = 0
	var catal = [0, 0]
	var STR
	var AGI
	var VIT
	var TEN
	var WIS
	var FER

	func _init(name, species, color, ap_vec, level, gradations):
		self.name = name
		self.species = species
		self.color = color
		self.ap_vec = ap_vec
		self.level = level
		self.STR = gradations[0]
		self.AGI = gradations[1]
		self.VIT = gradations[2]
		self.TEN = gradations[3]
		self.WIS = gradations[4]
		self.FER = gradations[5]


func _ready():
	print("Game Menu")
	monster_generate("nhi", Color(-1, -1, -1), [], [3, 1], [2, 2, 1, 0, 0, 0], 1)

############  BUTTONS  ############

func _on_ToBreed_pressed():
	monster_generate("nhi", Color(-1, -1, -1), [], [3, 1], [2, 2, 1, 0, 0, 0], 1)

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

# To randomize SPECIES; the string must be an invalid species' name
# To randomize COLOR; color must be Color(-1, -1, -1)
# LEVEL is vector such as [avarage level, accepted variation]
# GRADATIONS must be in order [STR, AGI, VIT, TEN, WIS, FER]; 0-7 = F-S; blanks will be randomized
# VARIATION defines how much non-blank gradations can be randomized. 0 and 7 are not randomized
func monster_generate(species, color, apendices, level, gradations, variation):
	var info # [species, color]
	var name
	var lvl
	var monster
	var grad = []

	randomize()
	info = monster_sprite(species, color, Vector2(220, 220))

	var count = 1
	for mon in mon_depo:
		if( mon.species == info[0] ):
			count += 1
	name = str(info[0], count)

	lvl = level[0] + (randi() % (level[1] + 1)) - (randi() % (level[1] + 1))
	if( lvl < 1 ):
		lvl = 1

	count = 0
	for stat in gradations:
		grad.append(stat)
		if( stat != 0 and stat != 7 ):
			grad[count] = stat + (randi() % (variation + 1)) - (randi() % (variation + 1))
			if( grad[count] < 0 ):
				grad[count] = 0
			elif( grad[count] > 7 ):
				grad[count] = 7
		count += 1

	monster = Monster.new(name, info[0], info[1], [], lvl, grad)

	mon_depo.append(monster)


# Generates monster's sprite. More information in monster_generate() documentation
func monster_sprite(species, color, pos):
	var creature = creature_scn.instance()
	var id = creature.get_id(species)
	var col = color

	if( id == -1 ):
		id = randi() % creature.pos_database.size()

	if( col == Color( -1, -1, -1) ):
		col = Color( rand_range(0.1, 1), rand_range(0.1, 1), rand_range(0.1, 1))

	creature.prepare(id, col)
	creature.set_pos(pos)

	add_child(creature)

	return [creature.get_species(id), col]