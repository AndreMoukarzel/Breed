
extends Control


var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

# Empiric information
var box_size = Vector2(225, 150)
var box_scale = Vector2(0.75, 0.75)

var page = 0 # displayed page
var last_unit_pressed = "-1"

# Local information, relevant to facilitate acess to information
# on each case SelectBox is used
var mon_vec
var page_amount = 0
var max_cols = 0
var max_pages = 0

#precisa ter uma flag que determina se existem elementos vazios na pagina,
#para travar a seta de próximo caso existam. Ou isso, ou contar o numero de
#bixos no vetor, para definir o numero de paginas possiveis

func generate_members(monster_vec, number_per_page, max_columns):
	var s_count = 0 # spacing counter
	var size = box_size * box_scale

	# Recebendo dados relevantes mais novos.
	mon_vec = monster_vec
	page_amount = number_per_page
	max_cols = max_columns
	max_pages = ceil(monster_vec.size() / page_amount)
	

	for num in range (page * number_per_page, (page + 1) * number_per_page):
		var newunit = boxunit_scn.instance()
		newunit.set_name(str(num))
		#falta settar posição, espaçamento, etc
		if (monster_vec.size() <= num):
			newunit.set_disabled(true)
		else:
			var mon = monster_vec[num]
			var db = get_node("/root/Monster")
			db.monster_sprite(newunit, db.get_id(mon.species), mon.color, Vector2(30,40), Vector2(0.1, 0.1))

		newunit.set_pos(Vector2(size.x * (s_count % max_columns), size.y * floor(s_count / max_columns)))
		s_count += 1
		add_child(newunit)

	var Fp = get_node("FowardPage")
	var Bp = get_node("BackPage")
	Fp.set_pos(Vector2((size.x * max_columns) - Fp.get_size().x - 10, (size.y * number_per_page / max_columns) + 10))
	Bp.set_pos(Vector2(10, (size.y * number_per_page / max_columns) + 10))


func clean_box():
	for num in range(page * page_amount, page + 1 * page_amount):
		get_node(str(num)).queue_free()

####### BUTTON FUNCIONALITY #######

func button_pressed(body):
	if((last_unit_pressed != "-1") and (last_unit_pressed != body.get_name())):
		get_node(last_unit_pressed).set_pressed(false)
		get_node(last_unit_pressed).set_ignore_mouse(false)
	last_unit_pressed = body.get_name()


func _on_BackPage_pressed():
	clear_box()
	page = (page - 1) % max_pages

	generate_members(mon_vec, page_amount, max_cols)


func _on_FowardPage_pressed():
	clear_box()
	page = (page + 1) % max_pages

	generate_members(mon_vec, page_amount, max_cols)