
extends Control

const PDB = preload("PersonalityDatabase.gd")
onready var personality_db = PDB.new()

var selected_id = -1
var comp_depo = []

func _ready():
	pass

func select_monster(monster, select_box):
	get_parent().select_monster(monster, select_box)

func _on_Rank1_pressed():
	# Vai ter que gerar os monstros para uma batalha de Rank 1,
	# e começar a representação visual.
	generate_enemies(1, 5)
	if (process_battle(2)):
		print ("Total victory!")
		#colocar aqui para desbloquear os outros ranks
	else:
		print ("Ya lost boi")
	comp_depo.clear()


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
	var mon1
	
	for monster in global.mon_depo:
		if monster.idn == selected_id:
			mon1 = monster
	
	# The monster's battle state: monster, HP, status conditions
	var mon1_battle_state = [mon1, mon1.stats[2] * 3, []]
	var mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, []]
	
	comp_depo.pop_front()
	
	# The battle number
	var battle_num = 1
	
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
				if(check_win_lose("win", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
					return true
				# Reset monster 1 turn counter
				mon1_turn = 0
				# Turno do monstro 2 em seguida
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
					return false
				mon2_turn = 0
				
			else:
				# Turno do monster 2 primeiro
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
					return false
				mon2_turn = 0
				# Turno do monstro 1 em seguida
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
					return true
				mon1_turn = 0
		elif (mon1_turn >= 100):
			# Turno do monstro 1
			process_action(mon1_battle_state, mon2_battle_state)
			if(check_win_lose("win", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
				return true
			mon1_turn = 0
		elif (mon2_turn >= 100):
			# Turno do monster 2
			process_action(mon2_battle_state, mon1_battle_state)
			if(check_win_lose("lose", battle_num, enemy_num, mon1_battle_state, mon2_battle_state)):
				return false
			mon2_turn = 0

func check_win_lose(wl, battle_num, enemy_num, mon1_battle_state, mon2_battle_state):
	if (wl == "win"):
		if (mon2_battle_state[1] <= 0):
			#test
			print("Player Victory")
			if (battle_num < enemy_num):
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
	regular_attack(attacker_bs, reciever_bs)
	
func regular_attack(attacker_bs, reciever_bs):
	reciever_bs[1] -= abs(ceil(attacker_bs[0].stats[0] * 0.85))