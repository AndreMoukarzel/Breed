
extends Control

var boxunit_scn = preload("res://Scenes/SelectBoxUnit.tscn")

var page = 0 #pagina atual sendo exibida, da box

func _ready():
	pass
	
func generate_members (monster_vec, number_per_page, max_columns, spacing):
	var count = 0 #conta se, na pagina atual exibida, existem expacos vazios
	
	for num in range (page * number_per_page, (page + 1) * number_per_page):
		var newunit = boxunit_scn.instance()
		newunit.set_name(str(num))
		#falta settar posição, espaçamento, etc
		if (monster_vec.size() <= num):
			newunit.set_disabled(true)
			newunit.set_ignore_mouse(true)
		else:
			newunit.set_normal_texture(load(str("res://Resources/Sprites/Creatures/", monster_vec[num].species, "/", monster_vec[num].species, ".png")))
			newunit.set_disabled_texture(load(str("res://Resources/Sprites/Creatures/", monster_vec[num].species, "/", monster_vec[num].species, ".png")))
			newunit.set_texture_scale(Vector2(0.5, 0.5))
		add_child(newunit)


