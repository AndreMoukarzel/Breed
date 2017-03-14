
extends TextureButton


func _ready():
	connect("pressed", get_parent(), "button_pressed", [self])


func set_info(monster):
	get_node("Name").set_text(monster.name)
	get_node("Name").show()

func _on_SelectBoxUnit_pressed():
	set_ignore_mouse(true)
