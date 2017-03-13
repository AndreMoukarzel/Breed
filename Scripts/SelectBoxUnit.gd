
extends TextureButton


func _ready():
	connect("pressed", get_parent(), "button_pressed", [self])


func _on_SelectBoxUnit_pressed():
	set_ignore_mouse(true)
