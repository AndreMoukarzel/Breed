
extends Control


var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

# Empiric information
var box_size = Vector2(225, 150)
var box_scale = Vector2(0.75, 0.75)

var page = 0 # displayed page
var last_unit_pressed = "-1"

# Local information on box configuration
var mon_vec
var page_amount = 0
var max_cols = 0
var max_pages = 0


func update_config(monster_vec, number_per_page, max_columns):
	mon_vec = monster_vec
	page_amount = number_per_page
	max_cols = max_columns
	max_pages = int(ceil(float(monster_vec.size()) / float(page_amount)))

	# Position page managing arrows and text acording to new config
	var size = box_size * box_scale
	var Fp = get_node("FowardPage")
	var Bp = get_node("BackPage")
	var Pd = get_node("PageDisplay")
	Fp.set_pos(Vector2((size.x * max_cols) - Fp.get_size().x - 10, (size.y * page_amount / max_cols) + 10))
	Bp.set_pos(Vector2(10, (size.y * page_amount / max_cols) + 10))
	Pd.set_pos(Vector2(size.x/2 + Pd.get_size().x + 25, (size.y * page_amount / max_cols) + 10))

	Pd.set_text(str(page + 1, "/", max_pages))


# Create page_amount SelectBoxUnit, filling them acordingly 
func generate_members():
	var s_count = 0 # spacing counter
	var size = box_size * box_scale

	for num in range (page * page_amount, (page + 1) * page_amount):
		var newunit = boxunit_scn.instance()
		newunit.set_name(str(num))

		if (mon_vec.size() <= num):
			newunit.get_node("Button").set_disabled(true)
		else:
			var mon = mon_vec[num]
			var db = get_node("/root/Monster")
			db.monster_sprite(newunit, db.get_id(mon.species), mon.color, Vector2(50,90), Vector2(0.15, 0.15))
			newunit.set_info(mon)

		newunit.set_pos(Vector2(size.x * (s_count % max_cols), size.y * floor(s_count / max_cols)))
		newunit.set_scale(Vector2(0.75, 0.75))
		s_count += 1
		add_child(newunit)


func clear_box():
	for num in range(page * page_amount, page + 1 * page_amount):
		get_node(str(num)).set_name(str("old", get_node(str(num)).get_name()))
		get_node(str("old", num)).queue_free()


####### BUTTON FUNCIONALITY #######

func button_pressed(body):
	if((last_unit_pressed != "-1") and (last_unit_pressed != body.get_name())):
		get_node(last_unit_pressed).get_node("Button").set_pressed(false)
		get_node(last_unit_pressed).get_node("Button").set_ignore_mouse(false)
	last_unit_pressed = body.get_name()


func _on_BackPage_pressed():
	clear_box()
	page = (page - 1) % max_pages

	generate_members()


func _on_FowardPage_pressed():
	clear_box()
	page = (page + 1) % max_pages

	generate_members()