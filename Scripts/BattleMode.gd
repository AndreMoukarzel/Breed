
extends Control

var mon = null
var comp_depo = []

var battle_num
var mon1_battle_state
var mon2_battle_state

var anim_scn
var anim_list = []
# Used for animation purposes, contains the player monster,
# followed by the rest of the arena monsters.
var mon_list = []


func generate_enemies(rank, number):
	# Placeholder, deve depender do rank para gerar os monstros.
	for num in range (0, number):
		g_monster.monster_generate(comp_depo, "nhi", Color(-1, -1, -1), [2, 2, 1, 0, 0, 0], 9, 1)


func process_battle(enemy_num):
	# The battle will have a couple of commands that can be
	# chosen by the monsters. When a command is issued, the
	# respective animation should be played, hence why all
	# commands are separated on their on functions.

	# Preparing the ground for
	# displaying the battle animation.
	anim_list.clear()
	mon_list.clear()
	
	mon_list.append(mon)
	for monster in comp_depo:
		mon_list.append(monster)

	# Poderia usar também o mon#_battle_state[3]
	anim_list.append(["Idle", "Player"])
	anim_list.append(["Idle", "Enemy"])

	# Getting player monster
	var mon1 = mon

	# The monster's battle state: monster, HP, status conditions ([[effect, quantity, turns_left], [status, quantity, turns_left]...]
	mon1_battle_state = [mon1, mon1.stats[2] * 3, [], "Player"]
	mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, [], "Enemy"]

	comp_depo.pop_front()

	# The battle number
	battle_num = 1

	# A monster's turn happens when the counter reaches 100
	var mon1_turn = 0
	var mon2_turn = 0

	# Battle Loop
	while (true):
		# Adding the speed to the turn counter
		mon1_turn += mon1_battle_state[0].stats[1]
		mon2_turn += mon2_battle_state[0].stats[1]

		if (mon1_turn >= 100 and mon2_turn >= 100):
			# SPEED TIE
			if (randf() < 0.5):
				# Turno do monster 1 primeiro
				if (deal_effect(mon1_battle_state) == 0):
					process_action(mon1_battle_state, mon2_battle_state)
					if(check_win_lose("win", enemy_num)):
						return true
					# Reset monster 1 turn counter
				mon1_turn = 0
				# Turno do monstro 2 em seguida
				if (deal_effect(mon2_battle_state) == 0):
					process_action(mon2_battle_state, mon1_battle_state)
					if(check_win_lose("lose", enemy_num)):
						return false
				mon2_turn = 0

			else:
				# Turno do monster 2 primeiro
				if (deal_effect(mon2_battle_state) == 0):
					process_action(mon2_battle_state, mon1_battle_state)
					if(check_win_lose("lose", enemy_num)):
						return false
				mon2_turn = 0
				# Turno do monstro 1 em seguida
				if (deal_effect(mon1_battle_state) == 0):
					process_action(mon1_battle_state, mon2_battle_state)
					if(check_win_lose("win", enemy_num)):
						return true
				mon1_turn = 0

		elif (mon1_turn >= 100):
			# Turno do monstro 1
			if (deal_effect(mon1_battle_state) == 0):
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", enemy_num)):
					return true
			mon1_turn = 0
		elif (mon2_turn >= 100):
			# Turno do monster 2
			if (deal_effect(mon2_battle_state) == 0):
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", enemy_num)):
					return false
			mon2_turn = 0


func check_win_lose(wl, enemy_num):
	if (wl == "win"):
		if (mon2_battle_state[1] <= 0):
			#test
			print("Player Victory")
			# Enqueue animation
			anim_list.append(["Death", "Enemy"])
			
			if (battle_num < enemy_num):
#				print("Entrei")
				battle_num += 1
				mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, [], "Enemy"]
				comp_depo.pop_front()
			else:
				return true
	if (wl == "lose"):
		if (mon1_battle_state[1] <= 0):
			#test
			print("Enemy Victory")
			#Enqueue animation
			anim_list.append(["Death", "Player"])
			return true
	
	return false


func process_action(attacker_bs, reciever_bs):
	#decide o uso de skills ou não baseado em sua WIS
	randomize()
	if (attacker_bs[0].stats[4] / 300 >= randf()):
		use_skill(attacker_bs, reciever_bs)
	else:
		regular_attack(attacker_bs, reciever_bs)


func regular_attack(attacker_bs, reciever_bs):
	
	# Damage Calculation
	reciever_bs[1] -= abs(ceil(attacker_bs[0].stats[0] * 0.85))
	
	# Animation
	# test
	print(str(attacker_bs[3], "'s Attack!"))
	anim_list.append(["BasicAttack", attacker_bs[3]])
	anim_list.append(["Idle", attacker_bs[3]])


func use_skill(attacker_bs, reciever_bs):
	# Primeiro sorteamos aleatóriamente entre as skills das
	# personalidades. Depois, a buscamos pela database (podemos
	# mostrar o nome na representação visual), e checamos seus tipos,
	# e aplicamos seus efeitos.
	var persona_id
	
	persona_id = attacker_bs[0].personas[floor(rand_range(0, attacker_bs[0].personas.size()))]
	
	var persona_types = personality_db.get_types(persona_id)
	var persona_formulas = personality_db.get_formulas(persona_id)
	var persona_counter = 0
	
	#test
	print (str("O monstro ", attacker_bs[0].name, " usou skill. Skill utilizada: ", personality_db.get_skill(persona_id)))
	
	# Check for type of damage
	for type in persona_types:
		
		var formula_result
		if (type != "None"):
			formula_result = interpret_formula(persona_formulas[persona_counter], attacker_bs)
		
		# Damage types
		if (type == "Damage"):
			reciever_bs[1] -= abs(ceil(formula_result))
		elif (type == "Heal"):
			attacker_bs[1] += abs(ceil(formula_result))
		elif (type ==  "Self-Damage"):
			attacker_bs[1] -= abs(ceil(formula_result))
		
		# Effects
		elif (type == "HealPerTurn"):
			check_repeat_skill(attacker_bs, type)
			attacker_bs[2].append(["HealPerTurn", formula_result, 5])
		elif (type == "Critial"):
			# Tirar o efeito "Damage" dos que são critical, e fazer
			# com que a formula seja a chance de ativar o crit, se
			# não ativar o crit da dano normal, se ativar da 1.3x Atk
			randomize()
			if (formula_result/100 >= randf()):
				#test
				print (str("Critical hit! Chance to get was ", formula_result/100))
				#sucess
				reciever_bs[1] -= abs(ceil(attacker_bs[0].stats[0] * 1.3))
			else:
				regular_attack(attacker_bs, reciever_bs)
		elif (type == "Paralysis"):
			if (check_repeat_skill(reciever_bs, type)):
				#test
				print("Skill repetida, esquece ela!")
				continue
			randomize()
			if (formula_result/100 >= randf()):
				#test
				print ("O alvo foi paralisado!")
				reciever_bs[2].append(["Paralysis", 0.25, 5])
		
		persona_counter += 1


func check_repeat_skill(target_bs, type):
	if (type == "HealPerTurn"):
		for effect in target_bs[2]:
			if (effect[0] == type):
				target_bs[2].remove(target_bs[2].find(effect))
		return false
		
	# Procedimento padrão: se tiver um repetido, confirma a repetição
	# e não utiliza uma skill do mesmo tipo.
	
	for effect in target_bs[2]:
		if (effect[0] == type):
			return true


func interpret_formula(formula, attacker_bs):
	# Formulas serão compostos apenas de operadores,
	# stats e numeros, sem parenteses, para facilitar
	# as operações.
	var expr_list = []
	var beg = 0
	var end = 0
	
	# Transform string expression into numbers and operators
	for char in formula:
		# Tem que transformar a expressão atual em algo real
		if (char == ' '):
			if (formula[beg].is_valid_float()):
				# Is an integer, transform it into one
				expr_list.append(formula.substr(beg, end-beg).to_float())
			else:
				# Is a String, check if operator stat,
				# then transform it into the correct one
				if (formula[beg].is_valid_identifier()):
					# Is a stat name, transform into stat number
					expr_list.append(attacker_bs[0].stats[string_to_stat_number(formula.substr(beg, end-beg))])
				else:
					# is an operator
					expr_list.append(formula.substr(beg, end-beg))
			
			end += 1
			beg = end
		# Continua adicionando a expressão atual até
		# encontrar o próximo espaço
		else:
			end += 1
	
	#test
	#print (formula)
	#print (expr_list)
	
	# Operate on formula
	var result
	while expr_list.size() > 1:
	# Possivelmente implementar outras operações
		if (expr_list[1] == "+"):
			result = expr_list[0] + expr_list[2]
			expr_list.pop_front()
			expr_list.pop_front()
			expr_list.pop_front()
			expr_list.push_front(result)
		elif (expr_list[1] == "*"):
			result = expr_list[0] * expr_list[2]
			expr_list.pop_front()
			expr_list.pop_front()
			expr_list.pop_front()
			expr_list.push_front(result)
		else:
			print("Erro de formato!")
	
	return expr_list[0]


func string_to_stat_number(stat):
	if (stat == "STR"):
		return 0
	if (stat == "AGI"):
		return 1
	if (stat == "VIT"):
		return 2
	if (stat == "TEN"):
		return 3
	if (stat == "WIS"):
		return 4
	if (stat == "FER"):
		return 5


func deal_effect(reciever_bs):
	# Utilizando-se do parametro "quantity" de como o effect é
	# guardado no battle_state, podemos evitar de calcular
	# repetidas vezes o valor do efeito no monstro.
	
	# This function has some values to return. Here is a reference:
	# 0 = nothing to report
	# 1 = end the reciever's turn
	
	#test
	print(str("Vetor de status do monstro ", reciever_bs[0].name, ":"))
	print (reciever_bs[2])
	
	var return_value = 0
	
	for effect in reciever_bs[2]:
		# Identify effect
		if (effect[0] == "HealPerTurn"):
			#test
			print (str("Healed ", abs(ceil(effect[1])), " this turn!"))
			reciever_bs[1] += abs(ceil(effect[1]))
		if (effect[0] == "Paralysis"):
			#test
			print ("Check paralysis!")
			randomize()
			if (effect[1] >= randf()):
				#test
				print ("It's fully paralysed!")
				return_value = 1
	
		effect[2] -= 1
		if (effect[2] <= 0):
			#test
			print (str("Skill named ", effect[0], " is done!"))
			reciever_bs[2].remove(reciever_bs[2].find(effect))
	
	return return_value

####### BUTTON FUNCIONALITY #######

func _on_Rank1_pressed():
	if (mon.acts == 0):
		print("Monster has no action points")
		return
	mon.acts = 0

	get_node("MonsterSelect/SelectBox").kill()
	get_node("MonsterSelect/SelectBox").generate_members()
	# Vai ter que gerar os monstros para uma batalha de Rank 1,
	# e começar a representação visual.
	generate_enemies(1, 2)
	
	# Initialize animation
	var animation_scene = preload("res://Scenes/BattleAnimation.tscn")
	var anim_scn = animation_scene.instance()
	
	if (process_battle(2)):
		# Animate here
		anim_scn.action_list = anim_list
		anim_scn.monster_list = mon_list
		
		add_child(anim_scn)
		anim_scn.animate_battle()
		yield(anim_scn, "battle_animation_finished")
		
		anim_scn.queue_free()
		
		print ("Total victory!")
		get_node("MonsterSelect/Rank2").show()
		global.handle_quesha(500)
	else:
		# Animate here too
		anim_scn.action_list = anim_list
		anim_scn.monster_list = mon_list
		
		add_child(anim_scn)
		anim_scn.animate_battle()
		yield(anim_scn, "battle_animation_finished")
		
		anim_scn.queue_free()
		
		print ("Ya lost boi")
	
	comp_depo.clear()


func _on_Rank2_pressed():
	print("Im fucking useless")


func _on_Rank3_pressed():
	print("I can literally do nothing")


func select_monster(monster, select_box):
		mon = monster
		get_node("MonsterSelect/BattleDisplay").show()
		get_node("MonsterSelect/BattleDisplay").display(mon)