
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
	var xp = [0, 0] # current and necessary to level up
	var acts = 0 # number of monster actions
	var catal = [0, 0] # [current, max]
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
		self.catal[1] = ceil(log(self.stats[3]) * 0.4)
		self.xp[1] = floor((5 * pow(self.level, 2))/3)


func _ready():
	print("Game Menu")


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
# GRADATIONS must be in order [STR, AGI, VIT, TEN, WIS, FER]; 0-7 = F-S
func monster_generate(deposit, species, color, apendices, gradations, level):
	var race = species
	var id
	var col = color
	var name
	var monster
	var grad = []
	var stats = []

	randomize()

	# Species
	id = g_monster.get_id(race)
	if( id == -1 ):
		id = randi() % g_monster.pos_database.size()
	race = g_monster.get_species(id)

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

	monster = Monster.new(name, randi() % 2, str(race), col, [], stats, grad)
	for lv in range (1, level):
		g_monster.level_up(monster)

	deposit.append(monster)


func _on_ToSleep_pressed():
	global.handle_days(1)
