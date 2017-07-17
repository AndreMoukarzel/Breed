extends Control

onready var timer = get_node("Display/Timer")
onready var displaytext = get_node("Display/Text")
onready var button = get_node("Display/Button")
onready var textback = get_node("Display/TextBackground")
onready var npc = get_node("NPCDisplay/NPC")
onready var npcbox = get_node("NPCDisplay/NPCBox")

var test_string = "Testando, 1, 2, 3"
var test_vector = ["Teste 1 2 3 4 5 6 7 8", "Batatinha"]

var dialog_pos = [Vector2(OS.get_window_size().x/4.25, OS.get_window_size().y/1.35)] #only dialog0 pos and size for now
var dialog_sizes = [Vector2(OS.get_window_size().x/2, OS.get_window_size().y/4)]

signal text_end

func _ready():
	var w_s = OS.get_window_size()
	# Make it only one text speech for now, and only one dialog position. We will haave to account
	# for the dialog box size once we start costumizing, and may haave to have a vector keeping track.
	customize(global.dialog_speed, Vector2(w_s.x/4.25, w_s.y/1.2), Vector2(w_s.x/2, w_s.y/4))
	
func customize(time, position, size):
	# Customize time
	timer.set_wait_time(time)
	
	#Customize position
	displaytext.set_pos(position + Vector2(10, 10))
	button.set_pos(position)
	textback.set_pos(position)
	
	#Customize size
	displaytext.set_size(size)
	button.set_size(size)
	
	# NPC Display
	npc.set_pos(Vector2(position.x + (displaytext.get_size().x/3), position.y/3))
	npcbox.set_pos(Vector2(position.x, position.y/1.055))

func print_text(text):
	displaytext.clear()
	for letter in text:
		timer.start()
		displaytext.add_text(letter)
		yield(timer, "timeout")
	
	
	emit_signal("text_end")
	
func set_npc_settings(character):
	npc.set_texture(load(str("res://Resources/Sprites/Characters/", character, ".png")))
	get_node("NPCDisplay/NPCBox/Label").set_text(character)

# Recieves a vector of strings, prints them in sequence, and once over, frees the instance of the text display.
func print_text_sequence(text_vector):
	for text in text_vector:
		print_text(text)
		yield(self, "text_end")
		yield(button, "pressed")
	#add fade out visual effect
	queue_free()
	