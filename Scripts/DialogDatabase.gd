extends Node

const CHARACTER = 0
# Given in a vector of vectors of strings.
const DIALOG = 1

var dialog_database = [
	{ # ID = 0
		CHARACTER : "Mayor",
		DIALOG: [
		# Dialogs related to debt payment
		["Hello kid. Time for your monthly payment.", "This time, i'll be taking 100. Thanks!"],
		["It's your boy, Gyro!"]
		]
	},
	{ # ID = 1
		CHARACTER : "Pippi",
		DIALOG: [
		["Have you seen my Pippi?", "Plz help me I cant see my pippi oh no."],
		["It's your pip, Pippi!"]
		]
	}
]

func get_id(character):
	for id in range(dialog_database.size()):
		if( dialog_database[id][CHARACTER] == character ):
			return id
	return -1

func get_character(id):
	return dialog_database[id][CHARACTER]

func get_dialog_sequence(id, number):
	return dialog_database[id][DIALOG][number]
