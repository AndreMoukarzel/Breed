
extends Control

# Passaremos um vetor de animações para reproduzir tudo depois

signal finished_animation

func handle_animation(target, animation):
	if (target == "Player"):
		get_node("Player/AnimationPlayer").play(animation)
		if (animation != "Idle"):
			yield(get_node("Player/AnimationPlayer"), "finished")
			emit_signal("finished_animation")
			
	elif (target == "Enemy"):
		if (animation == "Idle"):
			get_node("Enemy/AnimationPlayer").play(animation, 1, randf())
		else:
			get_node("Enemy/AnimationPlayer").play(animation)
			# O acima ainda fica esperando o yield mesmo para o Idle
			yield(get_node("Enemy/AnimationPlayer"), "finished")
			emit_signal("finished_animation")