
extends Node

func breed( m1, m2, barn ):
	# Game State Handling
	var arbonus = 1
	for persona in m1.personas:
		if (personality_db.get_types(persona)[0] == "RAC"):
			arbonus -= 0.1
	for persona in m2.personas:
		if (personality_db.get_types(persona)[0] == "RAC"):
			arbonus -= 0.1
			
	var cost = 2000 - floor((m1.stats[2] + m2.stats[2])/2 * 130 * arbonus)

	if (global.energy - cost < 0):
		# Give notice to player
		#test
		print("Can't let you do that, Star Fox")
		return
	else:
		global.handle_energy(-cost)

	# Actual Breeding Function
	var species
	var color
	var rand

	if (m1.last_breed != m2 or m2.last_breed != m1):
			m1.bonus_preg = 0
			m2.bonus_preg = 0

	var chance
	if ((m1.gender == 0 and m2.gender == 0) or (m1.gender == 1 and m2.gender == 1)):
		chance = 0
	else:
		chance = floor(log((m1.stats[5] + m2.stats[5])/2) * 6) + m1.bonus_preg
		
	# Apply bonus chance from fertility personality
	for persona in m1.personas:
		if personality_db.get_types(persona)[0] == "BF":
			chance = floor(chance * 1.1)
	for persona in m2.personas:
		if personality_db.get_types(persona)[0] == "BF":
			chance = floor(chance * 1.1)

	randomize()
	if (randi() % 100 < chance): # Will have offspring
		m1.bonus_preg = 0
		m2.bonus_preg = 0
		# Offspring's species
		if (randi() % 2 == 0):
			species = str(m1.species)
		else:
			species = str(m2.species)
		print (species) # test
	
		# Offspring's color
		rand = randi()
		if (rand % 101 < 1):
			color = Color( rand_range(0.1, 1), rand_range(0.1, 1), rand_range(0.1, 1))
		elif (rand % 3 == 0):
			color = m1.color
		elif (rand % 3 == 1):
			color = m2.color
		else:
			var c1 = m1.color
			var c2 = m2.color
			color = Color((c1.r + c2.r)/2, (c1.g + c2.g)/2, (c1.b + c2.b)/2)
	
		var grads = randomize_grads(m1, m2)
		var personas = randomize_personas(m1, m2)

		g_monster.monster_generate(global.mon_depo, species, color, grads, personas, 1)

		# Sets incest count
		var inc = floor(max(m1.incest_count, m2.incest_count)) + check_incest(m1, m2)
		var new_mon = global.mon_depo[global.mon_depo.size() - 1]

		new_mon.incest_count = inc
		if (inc >= 4): # 2much incest PUNISHMENT
			new_mon.personas.clear()
			new_mon.personas.append(4)

		var offspring_display_scn = load("res://Scenes/DisplayOffspring.tscn")
		var display = offspring_display_scn.instance()
		barn.add_child(display)
		display.display(new_mon)
	else:
		m1.bonus_preg += 5
		m2.bonus_preg += 5

	xp_gain(m1, m2)

	m1.last_breed = m2
	m2.last_breed = m1
	m1.acts -= 1
	m2.acts -= 1


# Does exactly what is says
func check_incest(mon1, mon2):
	# It is impossible for one parent to be null, and the other not be.
	if (mon1.parent1_idn != null and mon2.parent1_idn != null):
		if (mon1.parent1_idn == mon2.parent1_idn or mon1.parent1_idn == mon2.parent2_idn):
			return 1
		elif (mon1.parent2_idn == mon2.parent1_idn or mon1.parent2_idn == mon2.parent2_idn):
			return 1
	if (mon1.idn == mon2.parent1_idn or mon1.idn == mon2.parent2_idn):
		return 2
	elif (mon2.idn == mon1.parent1_idn or mon2.idn == mon1.parent2_idn):
		return 2

	return 0


func randomize_grads(mon1, mon2):
	var grad = []

	for i in range(0, 6):
		var g1 = mon1.gradations[i]
		var g2 = mon2.gradations[i]

		if (g1 == 0 and g2 == 0):
			grad.append(0)
		else:
			randomize()
			var rand = randf()
			if (rand <= 0.05 and g1 < 6): # Growth chance 1
				grad.append(g1 + 1)
				continue
			rand = randf()
			if (rand <= 0.05 and g2 < 6): # Growth chance 1
				grad.append(g2 + 1)
				continue
			# Geração normal
			var rng = abs(g1 - g2) + 2
			rand = (randi() % rng) - 1
			var grd = min(g1, g2) + rand
			if (grd < 0):
				grd = 0

			grad.append(grd)
	return grad


func randomize_personas(mon1, mon2):
	var chance = 10
	var all_personas = []

	randomize()
	for i in range(3):
		var persona

		if (all_personas.size() >= 3):
			break

		if (mon1.personas.size() > i):
			if (randi() % 100 < chance):
				persona = mon1.personas[i]
				if (!all_personas.has(persona)):
					all_personas.append(persona)
		if (mon2.personas.size() > i):
			if (randi() % 100 < chance):
				persona = mon2.personas[i]
				if (!all_personas.has(persona)):
					all_personas.append(persona)

	if (all_personas.empty()):
		all_personas.append(randi() % 4)

	return all_personas


func xp_gain(mon1, mon2):
# STR, AGI, VIT, TEN, WIS, FER
	var m1bee = 1
	var m2bee = 1
	var m1bge = 1
	var m2bge = 1
	
	for persona in mon1.personas:
		if (personality_db.get_types(persona)[0] == "BEE"):
			m1bee += 0.1
		if (personality_db.get_types(persona)[0] == "BGE"):
			m1bge += 0.1
	for persona in mon2.personas:
		if (personality_db.get_types(persona)[0] == "BEE"):
			m2bee += 0.1
		if (personality_db.get_types(persona)[0] == "BGE"):
			m2bge += 0.1

	var m1xp = ceil(mon1.stats[1] * 0.8 * m1bge)
	var m2xp = ceil(mon2.stats[1] * 0.8 * m2bge)

	mon1.xp[0] += ceil((mon1.stats[4] * mon2.level + m2xp) * m1bee)
	mon2.xp[0] += ceil((mon2.stats[4] * mon1.level + m1xp) * m2bee)

	while (mon1.xp[0] >= mon1.xp[1]):
		g_monster.level_up(mon1)

	while (mon2.xp[0] >= mon2.xp[1]):
		g_monster.level_up(mon2)