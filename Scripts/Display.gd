
extends Control

var mon = null


func display( monster ):
	if mon != null: # clears old sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = monster

	get_node("StatusDisplayer").display(mon)
	get_node("StatusDisplayer").show()

	g_monster.monster_sprite(self, mon, Vector2(140, 150), Vector2(0.5, 0.5), true)


func kill():
	if mon != null: # clears sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = null
	get_node("StatusDisplayer").hide()
	get_node("StatusDisplayer").kill()