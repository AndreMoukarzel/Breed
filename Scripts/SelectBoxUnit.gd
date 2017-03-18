
extends Control

var mon = null

func set_info(monster):
	mon = monster
	get_node("Name").set_text(mon.name)
	get_node("Name").show()

func _on_Button_pressed():
	get_node("Button").set_ignore_mouse(true)
	get_parent().button_pressed(self)