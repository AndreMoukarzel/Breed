
extends Control


var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

# Empiric information
# Box = SelectBoxUnit
var box_size = Vector2(225, 150)
var box_scale = Vector2(0.75, 0.75)

var page = 0 # displayed page
var last_unit_pressed = "-1"
var selected_monster = null

# Local information on box configuration
var mon_vec
var page_amount = 0
var max_cols = 0
var max_pages = 0


func update_config(monster_vec, number_per_page, max_columns):
	mon_vec = monster_vec
	page_amount = number_per_page
	max_cols = max_columns
	max_pages = int(ceil(float(monster_vec.size()) / page_amount))

	# Position page managing arrows and text acording to new config
	var size = box_size * box_scale
	var Fp = get_node("FowardPage")
	var Bp = get_node("BackPage")
	var Pd = get_node("PageDisplay")
	Fp.set_pos(Vector2((size.x * max_cols) - Fp.get_size().x - 10, (size.y * page_amount / max_cols) + 10))
	Bp.set_pos(Vector2(10, (size.y * page_amount / max_cols) + 10))
	Pd.set_pos(Vector2((size.x * max_columns)/2 - Pd.get_size().x/2, (size.y * page_amount / max_cols) + 10))
	if (global.mon_depo.size() == 0):
		Pd.set_text("1/1")
	else:
		Pd.set_text(str(page + 1, "/", max_pages))

	# Special case
	if (max_pages <= 1):
		Fp.set_disabled(true)
		Bp.set_disabled(true)
	else:
		Fp.set_disabled(false)
		Bp.set_disabled(false)


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
			g_monster.monster_sprite(newunit, mon, Vector2(50,90), Vector2(0.15, 0.15), false)
			newunit.set_info(mon)

		newunit.set_pos(Vector2(size.x * (s_count % max_cols), size.y * floor(s_count / max_cols)))
		newunit.set_scale(Vector2(0.75, 0.75))
		s_count += 1
		add_child(newunit)


func clear_box():
	for num in range(page * page_amount, (page + 1) * page_amount):
		get_node(str(num)).set_name(str("old", get_node(str(num)).get_name()))
		get_node(str("old", num)).queue_free()


func kill():
	clear_box()
	last_unit_pressed = "-1"
	page = 0


####### BUTTON FUNCIONALITY #######

func button_pressed(body):
	if((last_unit_pressed != "-1") and (last_unit_pressed != body.get_name())):
		get_node(last_unit_pressed).get_node("Button").set_pressed(false)
		get_node(last_unit_pressed).get_node("Button").set_ignore_mouse(false)
	last_unit_pressed = body.get_name()
	get_parent().get_parent().select_monster(body.mon, self)


# Depends on outside methods to keep the last_unit_pressed
# (which is going to be pressed now).
func press_button(selected_id):
	get_node(str(selected_id, "/Button")).set_pressed(true)
	get_node(selected_id)._on_Button_pressed()


func _on_BackPage_pressed():
	if (global.mon_depo.size() != 0):
		clear_box()
		
		page -= 1
		if (page < 0):
			page = max_pages - 1
		
		# Adjustments
		get_node("PageDisplay").set_text(str(page + 1, "/", max_pages))
		last_unit_pressed = "-1"
	
		generate_members()


func _on_FowardPage_pressed():
	if (global.mon_depo.size() != 0):
		clear_box()
		
		page = (page + 1) % max_pages
		
		# Adjustments
		get_node("PageDisplay").set_text(str(page + 1, "/", max_pages))
		last_unit_pressed = "-1"

		generate_members()