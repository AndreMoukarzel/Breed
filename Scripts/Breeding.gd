
extends Control

export var BoxColumns = 2
export var PageAmount = 8

onready var Sbox1 = get_node("Storage1/SelectBox")
onready var Sbox2 = get_node("Storage2/SelectBox")
onready var tween1 = get_node("Storage1/Tween")
onready var tween2 = get_node("Storage2/Tween")

var blue = 0
var red = 0

var mon1 = -1
var mon2 = -1


func _ready():
	get_node("Storage1").set_pos(Vector2(20 - get_node("Storage1/StorageBackground1").get_size().x, 45))
	get_node("Storage2").set_pos(Vector2(OS.get_window_size().x - 20, 45))


func update_boxes():
	Sbox1.update_config(global.mon_depo, PageAmount, BoxColumns)
	Sbox1.generate_members()
	
	Sbox2.update_config(global.mon_depo, PageAmount, BoxColumns)
	Sbox2.generate_members()


func select_monster( monster, select_box ):
	var origin = select_box.get_parent().get_name()

	if( origin == "Storage1" ):
		get_node("Display1").display(monster)
		get_node("Display1/Collect1").show()
		get_node("Display1/Feed1").show()
		mon1 = monster.idn

		if (mon1 == mon2):
			var node = get_node(str("Storage2/SelectBox/", get_node("Storage2/SelectBox").last_unit_pressed))
			node.get_node("Button").set_pressed(false)
			node.get_node("Button").set_ignore_mouse(false)
			get_node("Storage2/SelectBox").last_unit_pressed = "-1"
			get_node("Display2").kill()
			get_node("Display2/Collect2").hide()
			get_node("Display2/Feed2").hide()
			mon2 = -1
	else:
		get_node("Display2").display(monster)
		get_node("Display2/Collect2").show()
		get_node("Display2/Feed2").show()
		mon2 = monster.idn

		if (mon1 == mon2):
			var node = get_node(str("Storage1/SelectBox/", get_node("Storage1/SelectBox").last_unit_pressed))
			node.get_node("Button").set_pressed(false)
			node.get_node("Button").set_ignore_mouse(false)
			get_node("Storage1/SelectBox").last_unit_pressed = "-1"
			get_node("Display1").kill()
			get_node("Display1/Collect1").hide()
			get_node("Display1/Feed1").hide()
			mon1 = -1

	if (mon1 != -1 and mon2 != -1):
		set_breed_info(mon1, mon2)

	if (mon1 == -1 or mon2 == -1):
		var info = get_node("Breed/Info")
		info.get_node("PregChance").set_text("0%")
		info.get_node("Cost").set_text("Cost:\n-1")


####### BUTTON FUNCIONALITY #######

func _on_Breed_pressed():
	# Positions in array mon_depo
	var id1 = null
	var id2 = null
	# Actual monster class instances
	var m1 = null
	var m2 = null

	if (mon1 == -1 or mon2 == -1):
		print ("No 2 monsters selected")
		return

	for i in range(global.mon_depo.size()):
		if (global.mon_depo[i].idn == mon1):
			id1 = i
			m1 = global.mon_depo[i]
		elif (global.mon_depo[i].idn == mon2):
			id2 = i
			m2 = global.mon_depo[i]
		if (id1 != null and id2 != null):
			break

	if (m1.acts == 0):
		print (str(m1.name, " has no action points"))
		return
	if (m2.acts == 0):
		print (str(m2.name, " has no action points"))
		return

	var pg1 = floor(id1/ Sbox1.page_amount)
	var pg2 = floor(id2/ Sbox2.page_amount)

	Sbox1.clear_box()
	Sbox2.clear_box()

	breed(m1, m2)

	set_breed_info(mon1, mon2)

	Sbox1.page = int(pg1)
	Sbox2.page = int(pg2)
	update_boxes()
	Sbox1.press_button(str(id1))
	Sbox2.press_button(str(id2))


func _on_Back_pressed():
	self.hide()
	
	Sbox1.kill()
	Sbox2.kill()
	get_node("Display1").kill()
	get_node("Display1/Collect1").hide()
	get_node("Display1/Feed1").hide()
	get_node("Display2").kill()
	get_node("Display2/Collect2").hide()
	get_node("Display2/Feed2").hide()
	mon1 = -1
	mon2 = -1

	if blue:
		_on_StorageBackground1_pressed()
	elif red:
		_on_StorageBackground2_pressed()

	var info = get_node("Breed/Info")
	info.get_node("PregChance").set_text("0%")
	info.get_node("Cost").set_text("Cost:\n-1")

	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()


func _on_StorageBackground1_pressed():
	var stor = get_node("Storage1")
	var bg = get_node("Storage1/StorageBackground1")

	if blue == 0:
		tween1.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() + Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		if red == 1:
			_on_StorageBackground2_pressed()
	else:
		tween1.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() - Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	bg.set_ignore_mouse(true)
	tween1.start()

	blue = (blue + 1) % 2


func _on_StorageBackground2_pressed():
	var stor = get_node("Storage2")
	var bg = get_node("Storage2/StorageBackground2")

	if red == 0:
		tween2.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() - Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		if blue == 1:
			_on_StorageBackground1_pressed()
	else:
		tween2.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() + Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	bg.set_ignore_mouse(true)
	tween2.start()

	red = (red + 1) % 2


func _on_Tween_tween_complete( object, key ):
	get_node("Storage1/StorageBackground1").set_ignore_mouse(false)
	get_node("Storage2/StorageBackground2").set_ignore_mouse(false)


func _on_Collect1_pressed():
	var monster
	for mon in global.mon_depo:
		if (mon.idn == mon1):
			monster = mon
			break

	if (monster.acts <= 0):
		print(str(monster.name, " has no strength left in its pipi"))
		return 

	for i in range(monster.acts):
		global.catal_depo.append(global.Catal.new(monster.species, monster.stats))

	monster.acts = 0
	Sbox1.clear_box()
	Sbox2.clear_box()
	update_boxes()


func _on_Collect2_pressed():
	var monster
	for mon in global.mon_depo:
		if (mon.idn == mon2):
			monster = mon
			break

	if (monster.acts <= 0):
		print(str(monster.name, " has no strength left in its pipi"))
		return 

	for i in range(monster.acts):
		global.catal_depo.append(global.Catal.new(monster.species, monster.stats))

	monster.acts = 0

	Sbox1.clear_box()
	Sbox2.clear_box()
	update_boxes()


func _on_Feed1_pressed():
	pass # replace with function body


func _on_Feed2_pressed():
	pass # replace with function body


############ BREED ############

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
		g_monster.incest += check_incest(m1, m2)
	
		var grads = randomize_grads(m1, m2)
	
		get_parent().monster_generate(global.mon_depo, species, color, [], grads, 1)
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


func set_breed_info(mon1, mon2):
	var m1 = null
	var m2 = null
	var info = get_node("Breed/Info")

	for i in range(global.mon_depo.size()):
		if (global.mon_depo[i].idn == mon1):
			m1 = global.mon_depo[i]
		elif (global.mon_depo[i].idn == mon2):
			m2 = global.mon_depo[i]
		if (m1 != null and m2 != null):
			break

	var chance = floor(log(m1.stats[5] + m2.stats[5]/2) * 6)
	var cost = 2000 - floor((m1.stats[2] + m2.stats[2])/2 * 130)

	if (m1.last_breed == m2 or m2.last_breed == m1):
			chance += m1.bonus_preg

	info.get_node("PregChance").set_text(str(chance, "%"))
	info.get_node("Cost").set_text(str("Cost:\n", cost))