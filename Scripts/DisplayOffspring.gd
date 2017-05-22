
extends Control

var mon
var name
var id1
var id2

func _ready():
	var w_size = OS.get_window_size()
	var bg = get_node("Background")

	bg.set_scale(Vector2(w_size.x/1920, w_size.y/1080))


func display(monster):
	mon = monster
	name = monster.name

	get_node("Display/LineEdit").set_placeholder(name)
	get_node("Display").display(mon)


func _on_LineEdit_text_changed( text ):
	name = get_node("Display/LineEdit").get_text()

	if (name == ""):
		name = mon.name


func _on_Accept_pressed():
	mon.name = name
	get_parent().mon_select_update()
	queue_free()


func _on_Refuse_pressed():
	global.mon_depo.pop_back()
	get_parent().mon_select_update()
	queue_free()