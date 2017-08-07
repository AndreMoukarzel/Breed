extends Control

var mon = null
var comp_depo = []


func generate_racers(rank, number):
	# Placeholder, deve depender do rank para gerar os monstros.
	for num in range (0, number):
		g_monster.monster_generate(comp_depo, "nhi", Color(-1, -1, -1), [2, 2, 1, 0, 0, 0], 9, 8)


func process_race(distance):
	# O monstro será representado por [monstro, distancia, contador_boost]
	
	var player_mon = [mon, 0, 0]
	var comp_mons = []

	for monster in comp_depo:
		comp_mons.append([monster, 0, 0])

	while (true):
		# Checa condição de vitória
		if (player_mon[1] >= distance):
			return true
		for num in range (0, comp_depo.size()):
			if (comp_mons[num][1] >= distance):
				return false
				
		# Sorteia ativação do super boost
		randomize()
		if (randf() < 0.01):
			player_mon[2] = player_mon[0].stats[3]
		for num in range (0, comp_depo.size()):
			randomize()
			if (randf() < 0.01):
				comp_mons[num][2] = comp_mons[num][0].stats[3]
		
		# Percorre alguma distancia
		if (player_mon[2] > 0):
			player_mon[1] += player_mon[0].stats[1] * 3
			player_mon[2] -= 1
		else:
			player_mon[1] += player_mon[0].stats[1]
			
		for num in range (0, comp_depo.size()):
			if (comp_mons[num][2] > 0):
				# comp_depo[num] equivale a comp_mons[num][0]
				comp_mons[num][1] += comp_depo[num].stats[1] * 3
				comp_mons[num][2] -= 1
			else:
				comp_mons[num][1] += comp_depo[num].stats[1]


####### BUTTON FUNCIONALITY #######

func _on_Rank1_pressed():
	if (mon == null):
		global.instance_warning(get_parent(), "Select a monster to fight!")
		print("Select a monster!")
		return
	if (mon.acts == 0):
		global.instance_warning(get_parent(), str(mon.name, " is too tired"))
		return
	mon.acts = 0

	get_node("MonsterSelect/SelectBox").kill()
	get_node("MonsterSelect/SelectBox").generate_members()
	# Vai ter que gerar os monstros para uma batalha de Rank 1,
	# e começar a representação visual.
	generate_racers(1, 5)
	if (process_race(1000)):
		print ("Total victory!")
		get_node("MonsterSelect/Rank2").show()
	else:
		print ("Ya lost boi")
	comp_depo.clear()


func _on_Rank2_pressed():
	print("Im fucking useless")


func _on_Rank3_pressed():
	print("I can literally do nothing")


func select_monster(monster, select_box):
		mon = monster
		get_node("MonsterSelect/RaceDisplay").show()
		get_node("MonsterSelect/RaceDisplay").display(mon)