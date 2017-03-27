
extends Control

onready var db = get_node("/root/Monster")
var mon = null


func display( monster ):
	if mon != null: # clears old sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = monster

	get_node("StatusDisplayer").display(mon)

	db.monster_sprite(self, db.get_id(mon.species), mon.color, Vector2(100, 150), Vector2(0.5, 0.5))


func kill():
	if mon != null: # clears sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = null
	get_node("StatusDisplayer").kill()