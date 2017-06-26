extends Node

const CHARACTER = 0
# Given in a vector of vectors of strings.
const DIALOG = 1

var dialog_database = [
	{ # ID = 0
		CHARACTER : "System",
		DIALOG: [
		# Dialogs related to alpha build
		["Hello! Welcome to Breed Project's Alpha. Click the text to continue!", "Your objective is have enough money to pay your debt at the end of each month.",
		 "You will be given some money to begin with. Try to figure out how to earn some nice cash! Good luck!"],
		["BOOP."]
		]
	},
	{ # ID = 1
		CHARACTER : "Mayor",
		DIALOG: [
		# Dialogs related to debt payment
		["Hello kid. Time for your monthly payment.", "This time, i'll be taking 100. Thanks!"],
		["It's your boy, Gyro!"]
		]
	},
	{ # ID = 2
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
