extends Node

const NAME = 0
const SKILL = 1
const TYPES = 2

# The formulas will be given in the same order as the types.
# I.e. if a skill is "Damage" and "Effect", and the effect is
# paralysis, the fomulas will be first for the damage, then for
# the paralysis CHANCE.

# NOTA IMPORTANTE: cada formula deve acabar com um whitespace, para
# que o interpretador consiga interpreta-la corretamente.

# As "n" primeiras personalidades serão personalidades "neutras",
# e a última sempre será a personalidade "Gorked".

const FORMULAS = 3

# Specifies if skill has a battle animation

const HAS_ANIM = 4

var personality_database = [
    ###########################################
	########## NEUTRAL PERSONALITIES ##########
    ###########################################
	{ # ID = 0
		NAME : "Sleepy",
		SKILL : "None",
		TYPES : ["None"],
		FORMULAS: [],
		HAS_ANIM: false
	},
	{ # ID = 1
		NAME : "Inert",
		SKILL : "None",
		TYPES : ["None"],
		FORMULAS: [],
		HAS_ANIM: false
	},
	{ # ID = 2
		NAME : "Motionless",
		SKILL : "None",
		TYPES : ["None"],
		FORMULAS: [],
		HAS_ANIM: false
	},
	{ # ID = 3
		NAME : "Apathetic",
		SKILL : "None",
		TYPES : ["None"],
		FORMULAS: [],
		HAS_ANIM: false
	},
    ##########################################
	########## TIER 1 PERSONALITIES ##########
    ##########################################
	{ # ID = 4
		NAME : "Calm",
		SKILL : "Regen",
		TYPES : ["Heal", "HealPerTurn"],
		FORMULAS: ["0.1 * VIT ", "0.05 * VIT "],
		HAS_ANIM: true
	},
	{ # ID = 5
		NAME : "Hot-Headed",
		SKILL : "Bash",
		TYPES : ["Damage", "None"],
		FORMULAS: ["1.15 * STR "],
		HAS_ANIM: true
	},
	{ # ID = 6
		NAME : "Stategist",
		SKILL : "Fatal Blow",
		TYPES : ["Critical"],
		FORMULAS: ["0.1 * WIS "],
		HAS_ANIM: true
	},
	{ # ID = 7
		NAME : "Awkward",
		SKILL : "Shocking Attack",
		TYPES : ["Damage", "Paralysis"],
		FORMULAS: ["0.75 * STR ", "0.1 * WIS "],
		HAS_ANIM: true
	},
	{ # ID = 8
		NAME : "Strong-Willed",
		SKILL : "Bonus Fertility",
		TYPES : ["BF"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 9
		NAME : "Glutton",
		SKILL : "Bonus Capacity",
		TYPES : ["BCC"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 10
		NAME : "Proactive",
		SKILL : "Bonus Actions",
		TYPES : ["BA"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 11
		NAME : "Tame",
		SKILL : "- Cost",
		TYPES : ["RAC"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 12
		NAME : "Perceptive",
		SKILL : "Bonus Exp",
		TYPES : ["BEE"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 13
		NAME : "Instructed",
		SKILL : "Bonus Training",
		TYPES : ["BGE"],
		FORMULAS: ["0 * WIS "],
		HAS_ANIM: false
	},
	{ # ID = 14
		NAME : "Gorked",
		SKILL : "Gork",
		TYPES : ["Self-Damage", "None"],
		FORMULAS: ["1.5 * STR ", "0.1 * WIS "],
		HAS_ANIM: true
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
	
func has_animation(id):
	return personality_database[id][HAS_ANIM]
	
func get_random_persona():
	randomize()
	return randi() % personality_database.size()
