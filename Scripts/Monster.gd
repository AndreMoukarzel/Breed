
extends Sprite

var creature_scn = preload("res://Scenes/Monster.tscn")

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
	# List of personality IDs
	var personas

	var last_breed = null
	var bonus_preg = 0
	var cost_decrease = 0
	var incest_count = 0

	func _init(name, gender, species, color, ap_vec, stats, gradations, personas):
		self.name = name
		self.gender = gender
		self.species = species
		self.color = color
		self.ap_vec = ap_vec
		self.stats = stats
		self.gradations = gradations
		self.personas = personas
		self.idn = global.get_id()
		self.catal[1] = 1 + ceil(log(self.stats[3]) * 0.4)
		self.xp[1] = floor((5 * pow(self.level, 2))/3)


const SPECIES = 0
const FACE_POS = 1
const AP_POS = 2
const STR_VEC = 3
const AGI_VEC = 4
const VIT_VEC = 5
const TEN_VEC = 6
const WIS_VEC = 7
const FER_VEC = 8


var pos_database = [
	{ # ID = 0
		SPECIES : "Mafagafo",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)],
		STR_VEC : [0.4, 0.05],
		AGI_VEC : [0.2, 0.02],
		VIT_VEC : [0.15, 0.02],
		TEN_VEC : [0.2, 0.03],
		WIS_VEC : [0.1, 0.01],
		FER_VEC : [0.3, 0.1]
	},
	{ # ID = 1
		SPECIES : "Vaking",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)],
		STR_VEC : [0.3, 0.05],
		AGI_VEC : [0.05, 0.02],
		VIT_VEC : [0.4, 0.1],
		TEN_VEC : [0.3, 0.02],
		WIS_VEC : [0.05, 0.05],
		FER_VEC : [0.3, 0.1]
	},
	{ # ID = 2
		SPECIES : "Biluga",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)],
		STR_VEC : [0.25, 0.05],
		AGI_VEC : [0.4, 0.1],
		VIT_VEC : [0.05, 0.02],
		TEN_VEC : [0.1, 0.02],
		WIS_VEC : [0.2, 0.1],
		FER_VEC : [0.3, 0.1]
	}
]


func get_id(species):
	for id in range(pos_database.size()):
		if( pos_database[id][SPECIES] == species ):
			return id
	return -1


func get_species(id):
	return pos_database[id][SPECIES]


func get_growth_rate(gradation, g_base, g_multi):
	return (g_base + (gradation * g_multi))


# We add 3 to count to access the right sections on the database
func level_up (monster):
	if (monster.level < 50):
		var growth = 0
		var p_d = pos_database[get_id(monster.species)]
	
		var count = 0
		# Grows stats
		for stat in monster.stats:
			growth = get_growth_rate(monster.gradations[count], p_d[count + 3][0], p_d[count + 3][1])
			randomize()
			# If growth rate surpasses 100%, one point is guaranteed,
			# and the chance for levelling another point in that same
			# stat is the % that exceeds 100%.
			if (growth > 1):
				monster.stats[count] += 1
				growth -= 1
				if (randf() <= growth):
					monster.stats[count] += 1
			else:
				if (randf() <= growth):
					monster.stats[count] += 1
			
			count += 1
	
		monster.xp[0] -= monster.xp[1]

		# Updates caps
		monster.catal[1] = 1 + ceil(log(monster.stats[3]) * 0.4)
		monster.level += 1
		monster.xp[1] = floor((5 * pow(monster.level, 2))/3)
	else:
		monster.xp[0] = 0


func prepare(id, color):
	var species = pos_database[id][SPECIES]

	set_texture(load(str("res://Resources/Sprites/Creatures/", species, "/", species, ".png")))
	set_modulate(color)

# Generates monster's sprite. More information in monster_generate() documentation
func monster_sprite(parent, id, color, pos, scale, behind):
	var creature = creature_scn.instance()

	creature.prepare(id, color)
	creature.set_pos(pos)
	creature.set_scale(scale)
	creature.set_draw_behind_parent(behind)

	parent.add_child(creature)


# To randomize SPECIES; the string must be an invalid species' name
# To randomize COLOR; color must be Color(-1, -1, -1)
# GRADATIONS must be in order [STR, AGI, VIT, TEN, WIS, FER]; 0-6 = F-S
func monster_generate(deposit, species, color, apendices, gradations, personas, level):
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

	monster = Monster.new(name, randi() % 2, str(race), col, [], stats, grad, personas)
	for lv in range (1, level):
		g_monster.level_up(monster)

	deposit.append(monster)