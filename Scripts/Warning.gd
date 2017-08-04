
extends Node2D

const CHAR_SIZE = 14

onready var label = get_node("Sprite/Label")
var completed = false

func _ready():
	
	get_node("Sprite").set_pos(Vector2(OS.get_window_size().x/2, 100))


func warn(warning_text):
	var text_size = warning_text.length() * CHAR_SIZE
	
	label.set_text(warning_text)
	get_node("Tween").interpolate_property(label, "rect/pos", Vector2(1000, -400), Vector2(-text_size/2, -400), 2, Tween.TRANS_BACK, Tween.EASE_OUT)
	get_node("Tween").start()



func _on_Tween_tween_complete( object, key ):
	if completed:
		get_node("AnimationPlayer").play("fade_out")

	get_node("Tween").interpolate_property(label, "rect/pos", label.get_pos(), Vector2(-1000, -400), 1, Tween.TRANS_BACK, Tween.EASE_IN, 1)
	get_node("Tween").start()

	completed = true


func _on_AnimationPlayer_finished():
	if completed:
		queue_free()
