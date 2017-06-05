extends Control

onready var timer = get_node("Display/Timer")
onready var displaytext = get_node("Display/Text")
onready var button = get_node("Display/Button")

var test_string = "Testando, 1, 2, 3"
var test_vector = ["Teste 1 2 3 4 5 6 7 8", "Batatinha"]

signal text_end

func _ready():
	var w_s = OS.get_window_size()
	#test
	customize(0.05, Vector2(w_s.x/4.25, w_s.y/1.35), Vector2(w_s.x/2, w_s.y/4))
	print_text_sequence(test_vector)
	
func customize(time, position, size):
	# Customize time
	timer.set_wait_time(time)
	
	#Customize position
	displaytext.set_pos(position)
	button.set_pos(position)
	
	#Customize size
	displaytext.set_size(size)
	button.set_size(size)

func print_text(text):
	displaytext.clear()
	for letter in text:
		timer.start()
		displaytext.add_text(letter)
		yield(timer, "timeout")
	
	
	emit_signal("text_end")

# Recieves a vector of strings, prints them in sequence, and once over, frees the instance of the text display.
func print_text_sequence(text_vector):
	for text in text_vector:
		print_text(text)
		yield(self, "text_end")
		yield(button, "pressed")
	