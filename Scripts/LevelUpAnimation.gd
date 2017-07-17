
extends Control

func animate(t, add):
	get_node("Label").set_text(str("UP ", t))
	set_pos(Vector2(320, 10 + (39 * add)))
	get_node("AnimationPlayer").play("Swoosh")
	yield(get_node("AnimationPlayer"), "finished")