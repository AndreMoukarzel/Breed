
extends Sprite

const SPECIES = 0
const FACE_POS = 1
const AP_POS = 2

var pos_database = [
	{ # ID = 0
		SPECIES : "Mafagafo",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
	},
	{ # ID = 1
		SPECIES : "Vaking",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
	},
	{ # ID = 2
		SPECIES : "Biluga",
		FACE_POS : Vector2(0, 0),
		AP_POS : [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
	}
]


func get_id(species):
	for id in range(pos_database.size()):
		if( pos_database[id][SPECIES] == species ):
			return id
	return -1


func get_species(id):
	return pos_database[id][SPECIES]


func prepare(id, color):
	var species = pos_database[id][SPECIES]

	set_texture(load(str("res://Resources/Sprites/Creatures/", species, "/", species, ".png")))
	set_modulate(color)