
extends Label

var amount = 0
var deposit
var cat_vec

func _ready():
	amount = 1

func update_display(depo, catal):
	deposit = depo
	cat_vec = catal
	if (catal.empty()):
		amount = 1
		get_node("More").set_disabled(true)
		get_node("More10").set_disabled(true)
		get_node("Less").set_disabled(true)
		get_node("Less10").set_disabled(true)
		return

	var max_num = 0

	for c in catal:
		if (depo[c][1] > max_num):
			max_num = depo[c][1]

	get_node("More").set_disabled(false)
	get_node("More10").set_disabled(false)
	get_node("Less").set_disabled(false)
	get_node("Less10").set_disabled(false)

	if (amount >= max_num):
		amount = max_num
		get_node("More").set_disabled(true)
		get_node("More10").set_disabled(true)
	if (amount <= 1):
		amount = 1
		get_node("Less").set_disabled(true)
		get_node("Less10").set_disabled(true)

	set_text(str(amount))


####### BUTTON FUNCIONALITY #######


func _on_Less_pressed():
	amount -= 1
	update_display(deposit, cat_vec)


func _on_Less10_pressed():
	amount -= 10
	update_display(deposit, cat_vec)


func _on_More_pressed():
	amount += 1
	update_display(deposit, cat_vec)


func _on_More10_pressed():
	amount += 10
	update_display(deposit, cat_vec)
