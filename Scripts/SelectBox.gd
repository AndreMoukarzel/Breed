
extends Control

var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

var page = 0 #pagina atual sendo exibida, da box
var last_unit_pressed = "-1"
#precisa ter uma flag que determina se existem elementos vazios na pagina,
#para travar a seta de próximo caso existam. Ou isso, ou contar o numero de
#bixos no vetor, para definir o numero de paginas possiveis

func _ready():
	pass
	
func generate_members (monster_vec, number_per_page, max_columns, spacing):
	var s_count = 0 #contador para facilitar o espaçamento
	
	for num in range (page * number_per_page, (page + 1) * number_per_page):
		var newunit = boxunit_scn.instance()
		newunit.set_name(str(num))
		#falta settar posição, espaçamento, etc
		if (monster_vec.size() <= num):
			#colocar uma textura de disabled aqui
			newunit.set_disabled(true)
			newunit.set_ignore_mouse(true)
		else:
			var mon = monster_vec[num]
			var db = get_node("/root/Monster")
			db.monster_sprite(newunit, db.get_id(mon.species), mon.color, Vector2(0,0), Vector2(0.15, 0.15))
			#gerar a sprite do bixo como filho do botao aqui
#			newunit.set_normal_texture(load(str("res://Resources/Sprites/Creatures/", monster_vec[num].species, "/", monster_vec[num].species, ".png")))
#			newunit.set_disabled_texture(load(str("res://Resources/Sprites/Creatures/", monster_vec[num].species, "/", monster_vec[num].species, ".png")))
#			newunit.set_texture_scale(Vector2(0.15, 0.15))
		newunit.set_pos(Vector2(spacing * (s_count % max_columns), spacing * (s_count / max_columns)))
		s_count += 1
		add_child(newunit)


func button_pressed(body):
	if((last_unit_pressed != "-1") and (last_unit_pressed != body.get_name())):
		get_node(last_unit_pressed).set_pressed(false)
		get_node(last_unit_pressed).set_ignore_mouse(false)
	last_unit_pressed = body.get_name()