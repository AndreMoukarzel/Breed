extends Node

const NAME = 0
const SKILL = 1
const TYPES = 2

# The formulas will be given in the same order as the types.
# I.e. if a skill is "Damage" and "Effect", and the effect is
# paralysis, the fomulas will be first for the damage, then for
# the paralysis chance.
# If there is, in fact, a effect, the effect will be specified
# after a "/", and should be retrieved using the "split" string
# function. To identify the effect, then, we will need to use the regular
# expression "^Effect".
const FORMULAS = 3

var personality_database = [
	{ # ID = 0
		NAME : "Calm",
		SKILL : "Regen",
		TYPES : ["Damage", "Effect/Paralysis"],
		FORMULAS: ["0.05 * VIT", "0.05 * WIS"]
	},
	{ # ID = 1
		NAME : "Hot-Headed",
		SKILL : "Bash",
		TYPES : ["Damage"],
		FORMULAS: ["0.05 * STR"]
	},
	{ # ID = 2
		NAME : "Stategist",
		SKILL : "Fatal Blow",
		TYPES : ["Damage", "Effect/Critical"],
		FORMULAS: ["0.05 * STR", "0.1 * WIS"]
	}
]

func get_id(name):
	for id in range(pos_database.size()):
		if( pos_database[id][NAME] == name ):
			return id
	return -1

func get_name(id):
	return pos_database[id][NAME]

func get_skill(id):
	return pos_database[id][SKILL]

func get_types(id):
	return pos_database[id][TYPES]
	
func get_formulas(id):
	return pos_database[id][FORMULAS]