
extends Control

# Actions are in the format [name, actor, damage, additional]
# Tem que passar os monstros para saber quando colocar na dela.
# Quando tiver qualquer animação de Death (ainda tem que identificar
# quem morre), tem que substituir a sprite se for pertinente (ou seja,
# não troca se for a morte do player, ou se for a morte do último monstro,
# tem que checar se o monster_list está vazio antes de trocar).
# Toda vez que for liberar, a gente da pop_front no monster_list.
# No começo, faz monster_sprite nos dois primeiros.

# Existem skills que exclusivamente geram status, para depois gerar efeito
# (tipo a que da regen, ou seja, HealPerTurn), logo, vai precisar de duas animações
# diferentes.

var action_list = []
var monster_list = []

signal battle_animation_finished

func animate_battle():
	g_monster.monster_sprite(self.get_node("Player/Monster"), monster_list[0], Vector2(0, 0), Vector2(0.25, 0.25), false)
	monster_list.pop_front()
	g_monster.monster_sprite(self.get_node("Enemy/Monster"), monster_list[0], Vector2(0, 0), Vector2(0.25, 0.25), false)
	monster_list.pop_front()
	
	for action in action_list:
		
		# Check if action is not a skill
		if (action[0] != "BasicAttack" and action[0] != "Death" and action[0] != "Idle"):
			# Play Skillbox animation
			get_node("SkillBox/SkillName").set_text(action[0])
			get_node("SkillBox/AnimationPlayer").play("ShowName")
			yield(get_node("SkillBox/AnimationPlayer"), "finished")
		
		# Player is the actor
		if (action[1] == "Player"):
			
			# Action has no numeric values attached
			if (action.size() <= 2):
				if (action[0] == "Idle"):
					get_node("Player/AnimationPlayer").play(action[0], 1, rand_range(0.8, 1.2))
				elif(action[0] == "Death"):
					get_node("Player/AnimationPlayer").stop()
					get_node("Player/AnimationPlayer").play(action[0])
					yield(get_node("Player/AnimationPlayer"), "finished")
				else:
					get_node("Player/AnimationPlayer").stop()
					get_node("Player/AnimationPlayer").play(action[0])
					yield(get_node("Player/AnimationPlayer"), "finished")
			
			# Action has numeric values attached
			else:
				# Action is damaging
				if (action[2] >= 0):
					get_node("Enemy/PopUpNumber").set("custom_colors/font_color", Color(255, 0, 0))
					get_node("Enemy/PopUpNumber").set_text(str(action[2]))
					
					get_node("Player/AnimationPlayer").stop()
					get_node("Player/AnimationPlayer").play(action[0])
					yield(get_node("Player/AnimationPlayer"), "finished")
					get_node("Enemy/AnimationPlayer").play("DamagePopUp")
					yield(get_node("Enemy/AnimationPlayer"), "finished")
				# Action is healing
				else:
					get_node("Player/PopUpNumber").set("custom_colors/font_color", Color(0, 255, 0))
					get_node("Player/PopUpNumber").set_text(str(-action[2]))
					
					get_node("Player/AnimationPlayer").stop()
					get_node("Player/AnimationPlayer").play(action[0])
					yield(get_node("Player/AnimationPlayer"), "finished")
					get_node("Player/AnimationPlayer").play("HealPopUp")
					yield(get_node("Player/AnimationPlayer"), "finished")
					
		
		# Enemy is the actor
		else:
			
			# Action has no numeric values attached
			if (action.size() <= 2):
				if (action[0] == "Idle"):
					get_node("Enemy/AnimationPlayer").play(action[0], 1, rand_range(0.8, 1.2))
				elif (action[0] == "Death"):
					get_node("Enemy/AnimationPlayer").stop()
					get_node("Enemy/AnimationPlayer").play(action[0])
					yield(get_node("Enemy/AnimationPlayer"), "finished")
					
					# Continua a batalha.
					if (monster_list.size() > 0):
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
			
			# Action has numeric values attached
			else:
				# Action is damaging
				if (action[2] >= 0):
					get_node("Player/PopUpNumber").set("custom_colors/font_color", Color(255, 0, 0))
					get_node("Player/PopUpNumber").set_text(str(action[2]))
					
					get_node("Enemy/AnimationPlayer").stop()
					get_node("Enemy/AnimationPlayer").play(action[0])
					yield(get_node("Enemy/AnimationPlayer"), "finished")
					get_node("Player/AnimationPlayer").play("DamagePopUp")
					yield(get_node("Player/AnimationPlayer"), "finished")
				# Action is healing
				else:
					get_node("Player/PopUpNumber").set("custom_colors/font_color", Color(0, 255, 0))
					get_node("Player/PopUpNumber").set_text(str(-action[2]))
					
					get_node("Enemy/AnimationPlayer").stop()
					get_node("Enemy/AnimationPlayer").play(action[0])
					yield(get_node("Enemy/AnimationPlayer"), "finished")
					get_node("Enemy/AnimationPlayer").play("HealPopUp")
					yield(get_node("Enemy/AnimationPlayer"), "finished")
					
	
	emit_signal("battle_animation_finished")

func _on_SkipButton_pressed():
	emit_signal("battle_animation_finished")
