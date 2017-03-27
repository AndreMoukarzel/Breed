
extends Control

class Monster:
	var idn
	var parent1_idn = null
	var parent2_idn = null
	var name
	var gender # 0 = male, 1 = female; 2 = hemafrodite?
	var species
	var color #will be vector
	var ap_vec #apendices
	var level = 1
	var xp = 0
	var catal = [0, 0]
	# STR, AGI, VIT, TEN, WIS, FER
	var stats
	var gradations

	var last_breed = null
	var cost_decrease = 0

	func _init(name, gender, species, color, ap_vec, stats, gradations):
		self.name = name
		self.gender = gender
		self.species = species
		self.color = color
		self.ap_vec = ap_vec
		self.stats = stats
		self.gradations = gradations
		self.idn = global.get_id()


func _ready():
	print("Game Menu")
	for i in range(10):
		monster_generate(global.mon_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 3)

############  BUTTONS  ############

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


##########  FUNCTIONALITY  ##########

# To randomize SPECIES; the string must be an invalid species' name
# To randomize COLOR; color must be Color(-1, -1, -1)
# GRADATIONS must be in order [STR, AGI, VIT, TEN, WIS, FER]; 0-7 = F-S; blanks will be randomized
func monster_generate(deposit, species, color, apendices, gradations, level):
	var race
	var id
	var col = color
	var name
	var monster
	var grad = []
	var stats = []
	var mon_database = get_node("/root/Monster") #global script

	randomize()

	# Species
	id = mon_database.get_id(race)
	if( id == -1 ):
		id = randi() % mon_database.pos_database.size()
	race = mon_database.get_species(id)

	# Color
	if( col == Color( -1, -1, -1) ):
		col = Color( rand_range(0.1, 1), rand_range(0.1, 1), rand_range(0.1, 1))

	# Name
	var count = 1
	for mon in deposit:
		if( mon.species == race ):
			if( mon.name != str(race, count) ):
				break
			count += 1
	name = str(race, count)

	# Gradations and Stats
	var newgrad = 0
	for stat in gradations:
		if (stat >= 0 and stat <= 7):
			newgrad = stat 
		else:
			newgrad = (randi() % 6) + 1
		grad.append(newgrad)
	
	# Defining stats
	stats = [5, 5, 5, 5, 5, 5]

	monster = Monster.new(name, randi() % 2, race, col, [], stats, grad)
	for lv in range (1, level):
		mon_database.level_up(monster)

	deposit.append(monster)
