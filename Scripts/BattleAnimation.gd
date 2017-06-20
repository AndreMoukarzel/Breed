
extends Control

# Actions are in the format [name, actor]
# Tem que passar os monstros para saber quando colocar na dela.
# Quando tiver qualquer animação de Death (ainda tem que identificar
# quem morre), tem que substituir a sprite se for pertinente (ou seja,
# não troca se for a morte do player, ou se for a morte do último monstro,
# tem que checar se o monster_list está vazio antes de trocar).
# Toda vez que for liberar, a gente da pop_front no monster_list.
# No começo, faz monster_sprite nos dois primeiros.

var action_list = []
var monster_list = []

func animate_battle():
	g_monster.monster_sprite(self.get_node("Player/Monster"), monster_list[0], Vector2(0, 0), Vector2(0.25, 0.25), false)
	monster_list.pop_front()
	g_monster.monster_sprite(self.get_node("Enemy/Monster"), monster_list[0], Vector2(0, 0), Vector2(0.25, 0.25), false)
	monster_list.pop_front()
	
	for action in action_list:
		if (action[1] == "Player"):
			if (action[0] == "Idle"):
				get_node("Player/AnimationPlayer").play(action[0], 1, max(0.4, randf()))
			else:
				get_node("Player/AnimationPlayer").stop()
				get_node("Player/AnimationPlayer").play(action[0])
				yield(get_node("Player/AnimationPlayer"), "finished")
		
		else:
			if (action[0] == "Idle"):
				get_node("Enemy/AnimationPlayer").play(action[0], 1, max(0.4, randf()))
			elif (action[0] == "Death" and monster_list.size() > 0):
				get_node("Enemy/AnimationPlayer").stop()
				get_node("Enemy/AnimationPlayer").play(action[0])
				yield(get_node("Enemy/AnimationPlayer"), "finished")
				
				for node in get_node("Enemy/Monster").get_children():
					node.queue_free()
				g_monster.monster_sprite(self.get_node("Enemy/Monster"), monster_list[0], Vector2(0, 0), Vector2(0.25, 0.25), false)
				monster_list.pop_front()
				
				get_node("Enemy/AnimationPlayer").stop()
				get_node("Enemy/AnimationPlayer").play("Emerge")
				yield(get_node("Enemy/AnimationPlayer"), "finished")
			else:
				get_node("Enemy/AnimationPlayer").stop()
				get_node("Enemy/AnimationPlayer").play(action[0])
				yield(get_node("Enemy/AnimationPlayer"), "finished")