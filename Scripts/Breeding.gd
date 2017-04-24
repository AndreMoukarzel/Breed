
extends Node


func breed( m1, m2 ):
	# Game State Handling
	var cost = 2000 - floor((m1.stats[2] + m2.stats[2])/2 * 130)

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

	var chance = floor(log(m1.stats[5] + m2.stats[5]/2) * 6) + m1.bonus_preg
	
	randomize()
	if (randi() % 100 <= chance): # Will have offspring
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
	
		# Checks incest
		var inc = check_incest(m1, m2)
		m1.incest_count += inc
		m2.incest_count += inc
	
		var grads = randomize_grads(m1, m2)
	
		g_monster.monster_generate(global.mon_depo, species, color, [], grads, 1)
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


func xp_gain(mon1, mon2):
# STR, AGI, VIT, TEN, WIS, FER
	var m1xp = ceil(mon1.stats[1] * 0.8)
	var m2xp = ceil(mon2.stats[1] * 0.8)

	mon1.xp[0] += mon1.stats[4] * mon2.level + m2xp
	mon2.xp[0] += mon2.stats[4] * mon1.level + m1xp

	while (mon1.xp[0] >= mon1.xp[1]):
		g_monster.level_up(mon1)

	while (mon2.xp[0] >= mon2.xp[1]):
		g_monster.level_up(mon2)