
extends Control

var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

var page = 0 # displayed page
var last_unit_pressed = "-1"


var mon_vec
var page_amount = 0
var max_cols = 0
var max_pages = 0
#precisa ter uma flag que determina se existem elementos vazios na pagina,
#para travar a seta de próximo caso existam. Ou isso, ou contar o numero de
#bixos no vetor, para definir o numero de paginas possiveis

func generate_members (monster_vec, number_per_page, max_columns, spacing):
	var s_count = 0 # spacing counter

	# Recebendo dados relevantes mais novos.
	mon_vec = monster_vec
	page_amount = number_per_page
	max_pages = ceil(monster_vec.size() / page_amount)
	max_cols = max_columns
	

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

		newunit.set_pos(Vector2(spacing * (s_count % max_columns), spacing * (s_count / max_columns)))
		s_count += 1
		add_child(newunit)

	get_node("FowardPage").set_pos(Vector2((100 * max_columns) - get_node("FowardPage").get_size().x, (100 * number_per_page / max_columns) + 10))
	get_node("BackPage").set_pos(Vector2(10, (100 * number_per_page / max_columns) + 10))


func clean_box():
	for num in range(page * page_amount, page + 1 * page_amount):
		get_node(str(num)).queue_free()


func button_pressed(body):
	if((last_unit_pressed != "-1") and (last_unit_pressed != body.get_name())):
		get_node(last_unit_pressed).set_pressed(false)
		get_node(last_unit_pressed).set_ignore_mouse(false)
	last_unit_pressed = body.get_name()


func _on_BackPage_pressed():
	clear_box()
	page = (page - 1) % max_pages

	generate_members(mon_vec, 

func _on_FowardPage_pressed():
	pass # replace with function body
