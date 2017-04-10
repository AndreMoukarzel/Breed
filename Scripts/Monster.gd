
extends Sprite

var creature_scn = preload("res://Scenes/Monster.tscn")
var incest = 0

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
		for stat in monster.stats:
			growth = get_growth_rate(monster.gradations[count], p_d[count + 3][0], p_d[count + 3][1])
			randomize()
			if (randf() <= growth):
				monster.stats[count] += 1
			count += 1
	
		monster.xp[0] -= monster.xp[1]
		monster.catal[1] = ceil(log(monster.stats[3]) * 0.4)
		monster.level += 1
		monster.xp[1] = floor((5 * pow(monster.level, 2))/3)
	else:
		monster.xp[0] = 0


func prepare(id, color):
	var species = pos_database[id][SPECIES]

	set_texture(load(str("res://Resources/Sprites/Creatures/", species, "/", species, ".png")))
	set_modulate(color)

# Generates monster's sprite. More information in monster_generate() documentation
func monster_sprite(parent, id, color, pos, scale):
	var creature = creature_scn.instance()

	creature.prepare(id, color)
	creature.set_pos(pos)
	creature.set_scale(scale)

	parent.add_child(creature)