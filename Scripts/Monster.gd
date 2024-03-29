
extends Sprite

var creature_scn = preload("res://Scenes/Monster.tscn")

const PDB = preload("PersonalityDatabase.gd")
onready var personality_db = PDB.new()

class Monster:
	var idn
	var parent1_idn = null
	var parent2_idn = null
	var name
	var gender # 0 = male, 1 = female; 2 = hemafrodite?
	var species
	var color #will be vector
	var level = 1
	var xp = [0, 0] # current and necessary to level up
	var acts = 0 # number of monster actions
	var catal = [0, 0] # [current, max]
	# STR, AGI, VIT, TEN, WIS, FER
	var stats
	var gradations
	# List of personality IDs
	var personas
	# No formato [[quantity, lugar_no_vetor_de_stats], ...]
	# [Bonus 1, Bonus 2, Decrement 1, Decrement 2]
	var catal_boosts = []

	var last_breed = null
	var bonus_preg = 0
	var cost_decrease = 0
	var incest_count = 0

	var eye_tex
	var mouth_tex

	func _init(name, gender, species, color, stats, gradations, personas):
		self.name = name
		self.gender = gender
		self.species = species
		self.color = color
		self.stats = stats
		self.gradations = gradations
		self.personas = personas
		self.idn = global.get_id()
		
		randomize()
		eye_tex = str((randi() % 2) + 1) # "0" is for gorked 
		mouth_tex = str((randi() % 1) + 1) # "0" is for gorked
		
		var bccbonus = 1
		for persona in self.personas:
			if (personality_db.get_types(persona)[0] == "BCC"):
				bccbonus += 0.1
				
		self.catal[1] = 1 + ceil(log(self.stats[3]) * 0.4 * bccbonus)
		self.xp[1] = floor((5 * pow(self.level, 2))/3)


const SPECIES = 0
const FACE_POS = 1
const STR_VEC = 2
const AGI_VEC = 3
const VIT_VEC = 4
const TEN_VEC = 5
const WIS_VEC = 6
const FER_VEC = 7


var pos_database = [
	{ # ID = 0
		SPECIES : "Mafagafo",
		FACE_POS : [Vector2(261, 181), Vector2(338, 181), Vector2(300, 233)], # [left_eye, right_eye, mouth] 
		STR_VEC : [0.4, 0.05],
		AGI_VEC : [0.2, 0.02],
		VIT_VEC : [0.15, 0.02],
		TEN_VEC : [0.2, 0.03],
		WIS_VEC : [0.1, 0.01],
		FER_VEC : [0.3, 0.1]
	},
	{ # ID = 1
		SPECIES : "Vaking",
		FACE_POS : [Vector2(397, 150), Vector2(439, 144), Vector2(433, 214)],
		STR_VEC : [0.3, 0.05],
		AGI_VEC : [0.05, 0.02],
		VIT_VEC : [0.4, 0.1],
		TEN_VEC : [0.3, 0.02],
		WIS_VEC : [0.05, 0.05],
		FER_VEC : [0.3, 0.1]
	},
	{ # ID = 2
		SPECIES : "Biluga",
		FACE_POS : [Vector2(435, 157), Vector2(470, 164), Vector2(460, 236)],
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


func get_face_pos(id):
	return pos_database[id][FACE_POS]

func get_growth_rate(gradation, g_base, g_multi):
	return (g_base + (gradation * g_multi))


# We add 3 to count to access the right sections on the database
func level_up (monster):
	var stat_up_vec = []
	
	if (monster.level < 50):
		var growth = 0
		var p_d = pos_database[get_id(monster.species)]
	
		var count = 0
		# Grows stats
		for stat in monster.stats:
			growth = get_growth_rate(monster.gradations[count], p_d[count + 2][0], p_d[count + 2][1]) # gets all stats in database
			randomize()
			# If growth rate surpasses 100%, one point is guaranteed,
			# and the chance for levelling another point in that same
			# stat is the % that exceeds 100%.
			if (growth > 1):
				monster.stats[count] += 1
				growth -= 1
				if (randf() <= growth):
					monster.stats[count] += 1
					stat_up_vec.append(2)
				else:
					stat_up_vec.append(1)
			else:
				if (randf() <= growth):
					monster.stats[count] += 1
					stat_up_vec.append(1)
				else:
					stat_up_vec.append(0)
			
			count += 1
	
		monster.xp[0] -= monster.xp[1]

		# Updates caps
		
		# Identify catalyst capacity bonus from personality
		var bccbonus = 1
		for persona in monster.personas:
			if (personality_db.get_types(persona)[0] == "BCC"):
				bccbonus += 0.1
				
		monster.catal[1] = 1 + ceil(log(monster.stats[3]) * 0.4 * bccbonus)
		monster.level += 1
		monster.xp[1] = floor((5 * pow(monster.level, 2))/3)
	else:
		monster.xp[0] = 0
	
	return stat_up_vec

# Generates monster's sprite.
func monster_sprite(parent, monster, pos, scale, behind):
	var creature = creature_scn.instance() # possibly should be a Sprite.new() ???
	var id = get_id(monster.species)
	var species = monster.species
	var color = monster.color
	var face_pos = get_face_pos(id)
	
	creature.set_texture(load(str("res://Resources/Sprites/Creatures/", species, "/", species, ".png")))
	creature.set_modulate(color)

	creature.set_pos(pos)
	creature.set_scale(scale)
	creature.set_draw_behind_parent(behind)

	parent.add_child(creature)

	add_eyes(creature, face_pos, monster.eye_tex)
	add_mouth(creature, face_pos, monster.mouth_tex)


func add_eyes(parent, face_pos, texture):
	var eyel = Sprite.new()
	var eyer = Sprite.new()
	var face_offset = parent.get_texture().get_size() * Vector2(0.5, 0.5) #i dunno why its 0.5
	eyel.set_texture(load(str("res://Resources/Sprites/Creatures/Eyes/", texture, ".png")))
	eyer.set_texture(load(str("res://Resources/Sprites/Creatures/Eyes/", texture, ".png")))
	eyel.set_pos(face_pos[0] - face_offset)
	eyer.set_pos(face_pos[1] - face_offset)
	parent.add_child(eyel)
	parent.add_child(eyer)


func add_mouth(parent, face_pos, texture):
	var mouth = Sprite.new()
	var face_offset = parent.get_texture().get_size() * Vector2(0.5, 0.5) #i dunno why its 0.5
	mouth.set_texture(load(str("res://Resources/Sprites/Creatures/Mouths/", texture, ".png")))
	mouth.set_pos(face_pos[2] - face_offset)
	parent.add_child(mouth)


func determine_prominent_stats(mon_species):
	var db_id = get_id(mon_species)
	var det_vec = []
	for stat in range (2, 8): # gets all stats
		det_vec.append(pos_database[db_id][stat][0] + pos_database[db_id][stat][1])
	var max_vec = [0, 0]
	var min_vec = [1000, 1000]
	var max_index = [-1, -1]
	var min_index = [-1, -1]
	
	var counter = 0
	for num in det_vec:
		if (num > max_vec[0]):
			max_vec[1] = max_vec[0]
			max_vec[0] = num
			max_index[1] = max_index[0]
			max_index[0] = counter
		elif (num > max_vec[1]):
			max_vec[1] = num
			max_index[1] = counter
			
		counter += 1
		
	counter = 0
	for num in det_vec:
		if (num < min_vec[0]):
			min_vec[1] = min_vec[0]
			min_vec[0] = num
			min_index[1] = min_index[0]
			min_index[0] = counter
		elif (num < min_vec[1]):
			min_vec[1] = num
			min_index[1] = counter
		
		counter += 1
	
	return [max_index, min_index]


# To randomize SPECIES; the string must be an invalid species' name
# To randomize COLOR; color must be Color(-1, -1, -1)
# GRADATIONS must be in order [STR, AGI, VIT, TEN, WIS, FER]; 0-6 = F-S
func monster_generate(deposit, species, color, gradations, personas, level):
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
	
	# Defining personality
	# We will recieve a list of numbers, a number, or nothing.
	# If we recieve a number, we get a random persona in the interval (0, n) exclusive.
	# We have to put a list of IDs in the personas vector.
	var persona_ids = []
	
	if (typeof(personas) != TYPE_NIL):
		if (typeof(personas) == TYPE_ARRAY):
			for persona in personas:
				persona_ids.append(persona)
		elif (typeof(personas) == TYPE_INT):
			persona_ids.append(randi() % personas)
	else:
		# Gera alguma personalidade aleatória
		persona_ids.append(personality_db.get_random_persona())

	monster = Monster.new(name, randi() % 2, str(race), col, stats, grad, persona_ids)
	for lv in range (1, level):
		g_monster.level_up(monster)

	deposit.append(monster)