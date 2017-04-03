
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
	print("ID = ", monster.idn) #test

	if( origin == "Storage1" ):
		get_node("Display1").display(monster)
		mon1 = monster.idn

		if (mon1 == mon2):
			var node = get_node(str("Storage2/SelectBox/", get_node("Storage2/SelectBox").last_unit_pressed))
			node.get_node("Button").set_pressed(false)
			node.get_node("Button").set_ignore_mouse(false)
			get_node("Storage2/SelectBox").last_unit_pressed = "-1"
			get_node("Display2").kill()
			mon2 = -1
	else:
		get_node("Display2").display(monster)
		mon2 = monster.idn

		if (mon1 == mon2):
			var node = get_node(str("Storage1/SelectBox/", get_node("Storage1/SelectBox").last_unit_pressed))
			node.get_node("Button").set_pressed(false)
			node.get_node("Button").set_ignore_mouse(false)
			get_node("Storage1/SelectBox").last_unit_pressed = "-1"
			get_node("Display1").kill()
			mon1 = -1


####### BUTTON FUNCIONALITY #######

func _on_Breed_pressed():
	Sbox1.clear_box()
	Sbox2.clear_box()

	breed(mon1, mon2)

	update_boxes()


func _on_Back_pressed():
	self.hide()
	
	Sbox1.kill()
	Sbox2.kill()
	get_node("Display1").kill()
	get_node("Display2").kill()
	mon1 = -1
	mon2 = -1

	if blue:
		_on_StorageBackground1_pressed()
	elif red:
		_on_StorageBackground2_pressed()
	
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

############ BREED ############

func breed( monster_id1, monster_id2 ):
	# Game State Handling
	if (global.energy < 20):
		# Give notice to player
		#test
		print("Can't let you do that, Star Fox")
		return
	else:
		global.handle_energy(-20)
		
	# limit actions to 8PM
	if (global.time > 1200):
		# Give notice to player
		#test
		print("Go to bed boi")
		return
	else:
		global.handle_time(120)
	
	
	# Actual Breeding Function
	var m1 = null
	var m2 = null

	if (monster_id1 == -1 or monster_id2 == -1):
		print("escolhe dois monstros seu tolo")
		return 

	for mon in global.mon_depo:
		if (mon.idn == monster_id1):
			m1 = mon 
		elif (mon.idn == monster_id2):
			m2 = mon

		if ((m1 != null) and (m2 != null)):
			break

	var species
	var color
	var rand
	randomize()
	if (randi() % 2 == 0):
		species = m1.species
	else:
		species = m2.species

	rand = randi()
	if (rand % 3 == 0):
		color = m1.color
	elif (rand % 3 == 1):
		color = m2.color
	else:
		var c1 = m1.color
		var c2 = m2.color
		color = Color((c1.r + c2.r)/2, (c1.g + c2.g)/2, (c1.b + c2.b)/2)

	# Generate appendices
	g_monster.incest += check_incest(m1, m2)

	var grads = randomize_grads(m1, m2)

	get_parent().monster_generate(global.mon_depo, species, color, [], grads, 1)

	print("NAMES = ", m1.name, " and ", m2.name)


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
			if (rand <= 0.1 and g1 < 6):
				grad.append(g1 + 1)
				continue
			rand = randf()
			if (rand <= 0.1 and g2 < 6):
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