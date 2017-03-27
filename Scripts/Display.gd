
extends Control

onready var db = get_node("/root/Monster")
var mon


func display( monster ):
	mon = monster

	get_node("StatusDisplayer").display(mon)

	db.monster_sprite(self, db.get_id(mon.species), mon.color, Vector2(20, 10), Vector2(0.5, 0.5))