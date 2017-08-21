
extends Node2D

const ANIM_MAX = 4

signal anim_finished

func animate(mon1, mon2):
	var mon1_node = get_node("BreedingCenter/Monster1/Monster")
	var mon2_node = get_node("BreedingCenter/Monster2/Monster")
	var anim1 = mon1_node.get_node("AnimationPlayer")
	var anim2 = mon2_node.get_node("AnimationPlayer")

	g_monster.monster_sprite(mon1_node, mon1, Vector2(0, 0), Vector2(0.3, 0.3), false)
	g_monster.monster_sprite(mon2_node, mon2, Vector2(0, 0), Vector2(0.3, 0.3), false)

	randomize()
	anim1.play(str("breed", (randi() % ANIM_MAX) + 1))
	anim2.play(str("breed", (randi() % ANIM_MAX) + 1))


func _on_Timer_timeout():
	emit_signal("anim_finished")