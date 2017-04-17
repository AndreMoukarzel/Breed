
extends Control

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
		get_parent().get_parent().monster_generate(comp_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 1)

func process_battle(enemy_num):
	# The battle will have a couple of commands that can be
	# chosen by the monsters. When a command is issued, the
	# respective animation should be played, hence why all
	# commands are separated on their on functions.
	
	var mon1
	var mon2
	
	var battle_num = 1
	
	for monster in global.mon_depo:
		if monster.idn == selected_id:
			mon1 = monster
	
	mon2 = comp_depo[0]
	comp_depo.pop_front()
	
	# A monster's turn happens when the counter reaches 100
	var mon1_turn = 0
	var mon2_turn = 0
	
	var mon1_hp = mon1.stats[2] * 3
	var mon2_hp = mon2.stats[2] * 3
	
	while (true):
		mon1_turn += mon1.stats[1]
		mon2_turn += mon2.stats[1]
		if (mon1_turn >= 100 and mon2_turn >= 100):
			if (randf() < 0.5):
				# Turno do monster 1 primeiro
				mon2_hp -= process_action(mon1, mon2)
				if (mon2_hp <= 0):
					#test
					print("Player Victory")
					if (battle_num < enemy_num):
						battle_num += 1
						mon2 = comp_depo[0]
						comp_depo.pop_front()
					else:
						return true
			else:
				# Turno do monster 2 primeiro
				mon1_hp -= process_action(mon2, mon1)
				if (mon1_hp <= 0):
					#test
					print("Enemy Victory")
					return false
		elif (mon1_turn >= 100):
			pass
		elif (mon2_turn >= 100):
			pass
			
func process_action(mon1, mon2):
	#fazer baseado no WIS do monstro, por ora apenas gera um ataque normal
	return regular_attack(mon1, mon2)
	
func regular_attack(mon1, mon2):
	return abs(ceil(mon1.stats[0] * 0.85))
	