
extends Control

var mon = null

func set_info(monster):
	mon = monster

	get_node("Name").set_text(mon.name)
	get_node("Name").show()

	get_node("Level").set_text(str("lvl  ", mon.level))
	get_node("Level").show()

	get_node("Catals").set_text(str(mon.catal[0], "/", mon.catal[1]))
	get_node("Catals").show()


func _on_Button_pressed():
	get_node("Button").set_ignore_mouse(true)
	get_parent().button_pressed(self)