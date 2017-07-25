
extends Control

func animate(l_u_vec):
	for num in range (0, 6):
		get_node("Label").set_text(str("+ ", l_u_vec[num]))
		set_pos(Vector2(320, 30 + (39 * num)))
		get_node("AnimationPlayer").play("Zoom", 1, 1)
		yield(get_node("AnimationPlayer"), "finished")