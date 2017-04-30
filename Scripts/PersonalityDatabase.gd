extends Node

const NAME = 0
const SKILL = 1
const TYPES = 2

# The formulas will be given in the same order as the types.
# I.e. if a skill is "Damage" and "Effect", and the effect is
# paralysis, the fomulas will be first for the damage, then for
# the paralysis CHANCE.
# If there is, in fact, a effect, the effect will be specified
# after a "/", and should be retrieved using the "split" string
# function. To identify the effect (as in, to identify if it is
# an effect to begin with), then, we will need to use the regular
# expression "^Effect".
# NOTA IMPORTANTE: cada formula deve acabar com um whitespace, para
# que o interpretador consiga interpreta-la corretamente.
const FORMULAS = 3

var personality_database = [
	{ # ID = 0
		NAME : "Calm",
		SKILL : "Regen",
		TYPES : ["Damage", "HealPerTurn"],
		FORMULAS: ["0.1 * VIT ", "0.05 * VIT "]
	},
	{ # ID = 1
		NAME : "Hot-Headed",
		SKILL : "Bash",
		TYPES : ["Damage", "None"],
		FORMULAS: ["1.15 * STR "]
	},
	{ # ID = 2
		NAME : "Stategist",
		SKILL : "Fatal Blow",
		TYPES : ["Damage", "Critical"],
		FORMULAS: ["0.65 * STR ", "0.1 * WIS "]
	},
	{ # ID = 3
		NAME : "Awkward",
		SKILL : "Shocking Attack",
		TYPES : ["Damage", "Paralysis"],
		FORMULAS: ["0.75 * STR ", "0.1 * WIS "]
	},
	{ # ID = 4
		NAME : "Gorked",
		SKILL : "Gork",
		TYPES : ["Self-Damage", "None"],
		FORMULAS: ["1.5 * STR", "0.1 * WIS"]
	}
]

func get_id(name):
	for id in range(personality_database.size()):
		if( personality_database[id][NAME] == name ):
			return id
	return -1

func get_name(id):
	return personality_database[id][NAME]

func get_skill(id):
	return personality_database[id][SKILL]

func get_types(id):
	return personality_database[id][TYPES]
	
func get_formulas(id):
	return personality_database[id][FORMULAS]