
extends Control

const PDB = preload("PersonalityDatabase.gd")
onready var personality_db = PDB.new()

var mon = null
var comp_depo = []

var battle_num
var mon1_battle_state
var mon2_battle_state


func generate_enemies(rank, number):
	# Placeholder, deve depender do rank para gerar os monstros.
	for num in range (0, number):
		g_monster.monster_generate(comp_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 1)


func process_battle(enemy_num):
	# The battle will have a couple of commands that can be
	# chosen by the monsters. When a command is issued, the
	# respective animation should be played, hence why all
	# commands are separated on their on functions.

	# Getting player monster
	var mon1 = mon
	
	# The monster's battle state: monster, HP, status conditions
	mon1_battle_state = [mon1, mon1.stats[2] * 3, []]
	mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, []]

	comp_depo.pop_front()
	
	# The battle number
	battle_num = 1
	
	# A monster's turn happens when the counter reaches 100
	var mon1_turn = 0
	var mon2_turn = 0
	
	
	while (true):
		# Adding the speed to the turn counter
		mon1_turn += mon1_battle_state[0].stats[1]
		mon2_turn += mon2_battle_state[0].stats[1]
		
		if (mon1_turn >= 100 and mon2_turn >= 100):
			if (randf() < 0.5):
				# Turno do monster 1 primeiro
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", enemy_num)):
					return true
				# Reset monster 1 turn counter
				mon1_turn = 0
				# Turno do monstro 2 em seguida
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", enemy_num)):
					return false
				mon2_turn = 0
				
			else:
				# Turno do monster 2 primeiro
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", enemy_num)):
					return false
				mon2_turn = 0
				# Turno do monstro 1 em seguida
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", enemy_num)):
					return true
				mon1_turn = 0
		elif (mon1_turn >= 100):
			# Turno do monstro 1
			process_action(mon1_battle_state, mon2_battle_state)
			if(check_win_lose("win", enemy_num)):
				return true
			mon1_turn = 0
		elif (mon2_turn >= 100):
			# Turno do monster 2
			process_action(mon2_battle_state, mon1_battle_state)
			if(check_win_lose("lose", enemy_num)):
				return false
			mon2_turn = 0

func check_win_lose(wl, enemy_num):
	if (wl == "win"):
		if (mon2_battle_state[1] <= 0):
			#test
			print("Player Victory")
			if (battle_num < enemy_num):
#				print("Entrei")
				battle_num += 1
				mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, []]
				comp_depo.pop_front()
			else:
				return true
	if (wl == "lose"):
		if (mon1_battle_state[1] <= 0):
			#test
			print("Enemy Victory")
			return true
	
	return false
			
func process_action(attacker_bs, reciever_bs):
	#fazer baseado no WIS do monstro, por ora apenas gera um ataque normal
	randomize()
	if (attacker_bs[0].stats[4] / 300 < randi()):
		use_skill(attacker_bs, reciever_bs)
	else:
		regular_attack(attacker_bs, reciever_bs)
	
func regular_attack(attacker_bs, reciever_bs):
	reciever_bs[1] -= abs(ceil(attacker_bs[0].stats[0] * 0.85))

func use_skill(attacker_bs, reciever_bs):
	# Primeiro sorteamos aleatóriamente entre as skills das
	# personalidades. Depois, a buscamos pela database (podemos
	# mostrar o nome na representação visual), e checamos seus tipos,
	# e aplicamos seus efeitos.
	var persona_id
	
	persona_id = floor(rand_range(0, attacker_bs[0].personas.size() + 1))
	
	var persona_types = personality_db.get_types(persona_id)
	var persona_formulas = personality_db.get_formulas(persona_id)
	
	# Check for type of damage
	for type in persona_types:
		
		# Damage types
		if (type == "Damage"):
			pass
		elif (type == "Heal"):
			pass
		elif (type ==  "Self-Damage"):
			pass
		
		# Effects
		elif (type == "HealPerTurn"):
			pass
		elif (type == "Critial"):
			pass
		elif (type == "Paralysis"):
			pass

####### BUTTON FUNCIONALITY #######

func _on_Rank1_pressed():
	if (mon.acts == 0):
		print("Monster has no action points")
		return
	mon.acts = 0

	# Vai ter que gerar os monstros para uma batalha de Rank 1,
	# e começar a representação visual.
	generate_enemies(1, 2)
	if (process_battle(2)):
		print ("Total victory!")
		#colocar aqui para desbloquear os outros ranks
	else:
		print ("Ya lost boi")
	comp_depo.clear()


func _on_BackRank_pressed():
	get_node("MonsterSelect").show()
	get_node("RankSelect").hide()


func select_monster(monster, select_box):
		mon = monster
		get_node("MonsterSelect/BattleDisplay").show()
		get_node("MonsterSelect/BattleDisplay").display(mon)
		get_node("MonsterSelect/Proceed").set_disabled(false)
