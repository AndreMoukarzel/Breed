extends Node

var dialog_scn = preload("res://Scenes/DisplayText.tscn")
var dialog_speed = 0.025

const MAX_ENERGY = 3000

var ID = 0
var free_ids = []

var quesha = 1000

var year = 0
var month = 0
var days = 0

# Value of the debts you have to pay. To access the value
# for month/year, use debt_values[month][year]
var debt_values = [[100, 1000], [200, 2000], [300, 3000], [400, 4000], [500, 5000], [600, 6000], [700, 7000], [800, 8000], [900, 9000], [1000, 10000], [1100, 11000], [1200, 12000]]

# Maximum energy value is fixed, for now
var energy = MAX_ENERGY

var mon_depo = []
# Tratado como [[catal, quant], [catal, quant], ...]
var catal_depo = []

class Catal:
	var species
	var level # 1-3

	func _init(species, stats):
		self.species = species
		var sum = 0
		for stat in stats:
			sum += stat
		sum = sum/6
		if (sum <= 35):
			self.level = 1
		elif (sum <= 70):
			self.level = 2
		else:
			self.level = 3


var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


############ SCENE CHANGING ############

func goto_scene(path):

    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):

    # Immediately free the current scene,
    # there is no risk here.
	current_scene.free()

    # Load new scene
	var s = ResourceLoader.load(path)

    # Instance the new scene
	current_scene = s.instance()

    # Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )

########################################

func get_id():
	if free_ids.empty():
		ID += 1
		return ID - 1

	return free_ids.pop_front()


############ GLOBAL DISPLAYS ############

func handle_quesha(val):
	var path = get_tree().get_root().get_node("GameMenu/HUD/Quesha")
	quesha += val
	if (quesha < 0):
		print("ERROR: NEGATIVE QUESHA")
		quesha = 0
	path.set_text(str(quesha))


# Adds the value passed to the function to the energy
func handle_energy(val):
	var path = get_tree().get_root().get_node("GameMenu/HUD/Energy")
	energy += val
	if (energy < 0):
		energy = 0
	if (energy > MAX_ENERGY):
		energy = MAX_ENERGY
	path.set_value(energy)
	path.get_node("EnergyLabel").set_text(str(energy))


# Código de baixa qualidade. É possível melhorar facilmente.
func handle_days(val):
	var day_path = get_tree().get_root().get_node("GameMenu/HUD/DateAndTime/Date")
	
	# Updates day
	days += val
	
	# Checks for month passage, and lose condition
	if (days > 30):
		month += 1
		days = 1
		
		if (month > 12):
			year += 1
			month = 0
			
			if (quesha < debt_values[11][year - 1]):
				#test
				print("You lose the game my dude")
			else:
				instace_dialog(get_tree().get_root().get_node("GameMenu"), "Mayor Catto", month - 1)
				handle_quesha(-debt_values[11][year - 1])
		else:
			
			if (quesha < debt_values[month - 1][year]):
				#test
				print("You lose the game my dude")
			else:
				instace_dialog(get_tree().get_root().get_node("GameMenu"), "Mayor Catto", month - 1)
				handle_quesha(-debt_values[month - 1][year])
	
	handle_energy(MAX_ENERGY)
	day_path.set_text(str(days, " X ", month + 1, " X ", year + 1))

	# Updates catals and actions in monsters
	for mon in mon_depo:
		mon.catal[0] += mon.acts
		if (mon.catal[0] > mon.catal[1]):
			mon.catal[0] = 0

		var act = log(mon.stats[2])
		randomize()
		
		var apbonus = 1
		for persona in mon.personas:
			if (personality_db.get_types(persona)[0] == "BA"):
				apbonus += 0.3
				
		mon.acts = floor(rand_range(act - act/5, act + act/5) * apbonus)

########################################


# Implementar costumização da caixa de texto aqui depois
func instace_dialog(scene, character, dialog_number):
	var character_id = dialog_db.get_id(character)
	
	var d_s = dialog_scn.instance()
	scene.add_child(d_s)
	
	d_s.set_npc_settings(character)
	d_s.print_text_sequence(dialog_db.get_dialog_sequence(character_id, dialog_number))


func instance_warning(scene, warning_text):
	var warning = preload("res://Scenes/Warning.tscn").instance()
	
	warning.hide()
	scene.add_child(warning)
	warning.warn(warning_text)


func append_catal(deposit, catal, quant):
	for cq in deposit:
		if catal.species == cq[0].species and catal.level == cq[0].level:
			cq[1] += quant
			return
	deposit.append([catal, quant])


#func save():
#	var mons_idn = []
#	var mons_par1 = []
#	var mons_par2 = []
#	var mons_names = []
#	var mons_gender = []
#	var mons_species = []
#	var mons_color = []
#	var mons_level = []
#	var mons_xp = [] # double size
#	var mons_acts = []
#	var mons_catal = [] # double size
#	var mons_stats = [] # 6 times size
#	var mons_grads = [] # 6 times size
#	var mons_pers = [] # 3 times size
	# No formato [[quantity, lugar_no_vetor_de_stats], ...]
	# [Bonus 1, Bonus 2, Decrement 1, Decrement 2]
#	var catal_boosts = [] #?????
#
#	var last_breed = null
#	var bonus_preg = 0
#	var cost_decrease = 0
#	var incest_count = 0
#
#	var eye_tex = "dot"
#	var mouth_tex = "simple"
#
#	for mon in mon_depo:
#		mons_idn.append(mon.idn)
#		mons_par1.append(mon.parent1_idn)
#		mons_par2.append(mon.parent2_idn)
#		mons_names.append(mon.name)
#		mons_gender.append(mon.gender)
#		mons_species.append(mon.species)
#		mons_color.append(mon.color)
#		mons_level.append(mon.level)
#		for num in mon.xp:
#			mons_xp.append(num)
#		mons_acts.append(mon.acts)
#		for num in mon.catal:
#			mons_catal.append(num)
#		for num in mon.stats:
#			mons_stats.append(num)
#		for num in mon.gradations:
#			mons_grads.append(num)
#		for i in range(3):
#			if (mon.personas.size() - 1 < i):
#				mons_pers.append(-1)
#			else:
#				mons_pers.append(mon.personas[i])
#		catal_boost????

#	var i = 0
#	for unit in units_vector:
#		if unit == null:
#			units_vector.remove(i)
#		else:
#			total_units.append(unit)
#		i += 1
#	for unit in barracks:
#		total_units.append(unit)
#
#	for unit in total_units:
#		for weapon in unit.wpn_vector:
#			total_weapons.append(weapon)
#		for item in unit.item_vector:
#			total_items.append(item)
#	
#	var units = []
#	var weapons = []
#	var items = []
#	
#	var storage_weapons = []
#	var storage_items = []
#	
#	for unit in total_units:
#		# O numero de armas e items de cada unidade esta guardado ai mesmo
#		units.append( { id = unit.id, level = unit.level, wpn_num = unit.wpn_vector.size(), item_num = unit.item_vector.size() })
#	for weapon in total_weapons:
#		weapons.append( { id = weapon.id, durability = weapon.durability })
#	for item in total_items:
#		items.append( { id = item.id, amount = item.amount })
#	
#	print("Storage weapons:")
#	print(storage_wpn)
#	for weapon in storage_wpn:
#		storage_weapons.append( { id = weapon.id, durability = weapon.durability })
#	print("Storage items:")
#	print(storage_itm)
#	for item in storage_itm:
#		storage_items.append( { id = item.id, amount = item.amount })
#		
#	# Begin dictionary
#	var savedict = {
#		ID = ID,
#		free_ids = free_ids,
#		quesha = quesha,
#		year = year,
#		month = month,
#		day = day,
#		
#		active_units_size = units_vector.size(),
#		barracks_units_size = barracks.size(),
#		
#		units = units,
#		weapons = weapons,
#		items = items,
#		
#		storage_weapons = storage_weapons,
#		storage_items = storage_items
#		}
#		
#	return savedict
#
#
#func save_game():
#	var savegame = File.new()
#	var savedata = save()
#	savegame.open("user://savegame.save", File.WRITE)
#	savegame.store_line(savedata.to_json())
#	savegame.close()
#
#
#func load_game():
#	var savegame = File.new()
#	if !savegame.file_exists("user://savegame.save"):
#		print ("Load error")
#		return #Error!  We don't have a save to load
#
#	savegame.open("user://savegame.save", File.READ)
#	var savedata = {}
#	savedata.parse_json(savegame.get_as_text())
#	savegame.close()
#
#	first_play = savedata.first_play
#	
#	if first_play == 1:
#		return #Just came back from a party wipe
#	
#	stage = savedata.stage
#	quesha = savedata.quesha
#	victory = savedata.victory
#	
#	var wpns_iter
#	var current_wpn = 0
#	var items_iter
#	var current_item = 0
#
#	for i in range(0, savedata.active_units_size):
#		wpns_iter = 0
#		items_iter = 0
#		
#		var u = savedata.units[i]
#		units_vector.append(Unit.new(u.id, u.level, char_database))
#		while (wpns_iter < u.wpn_num):
#			units_vector[i].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
#			units_vector[i].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
#			wpns_iter += 1
#			current_wpn += 1
#		while (items_iter < u.item_num):
#			units_vector[i].item_vector.append(item.new(savedata.items[current_item].id, item_database))
#			units_vector[i].item_vector[items_iter].amount = savedata.items[current_item].amount
#			items_iter += 1
#			current_item += 1
#	
#	for i in range(savedata.active_units_size, savedata.active_units_size + savedata.barracks_units_size):
#		print (savedata.active_units_size)
#		print (savedata.barracks_units_size)
#		wpns_iter = 0
#		items_iter = 0
#		
#		var u = savedata.units[i]
#		barracks.append(Unit.new(u.id, u.level, char_database))
#		while (wpns_iter < u.wpn_num):
#			barracks[i - savedata.active_units_size].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
#			barracks[i - savedata.active_units_size].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
#			wpns_iter += 1
#			current_wpn += 1
#		while (items_iter < u.item_num):
#			barracks[i - savedata.active_units_size].item_vector.append(item.new(savedata.items[current_item].id, item_database))
#			barracks[i - savedata.active_units_size].item_vector[items_iter].amount = savedata.items[current_item].amount
#			items_iter += 1
#			current_item += 1
#	
#	if (current_wpn != savedata.weapons.size() or current_item != savedata.items.size()):
#		#Error handler, did not load correctly
#		print("Error loading data!")
#	
#	current_wpn = 0
#	current_item = 0
#	
#	for wpn in savedata.storage_weapons:
#		storage_wpn.append(weapon.new(wpn.id, wpn_database))
#		storage_wpn[current_wpn].durability = wpn.durability
#		current_wpn += 1
#	for itm in savedata.storage_items:
#		storage_itm.append(item.new(itm.id, item_database))
#		storage_itm[current_item].amount = itm.amount
#		current_item += 1
#	
#	if (current_wpn != savedata.storage_weapons.size() or current_item != savedata.storage_items.size()):
#		#Error handler, did not load correctly
#		print("Error loading data!")
#	
#	print ("Finished loading data!")
#	
#	scn = management_scn
#	get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
#	get_node("Music").set_loop(true)
#	get_node("Music").play()
#	
#	var level = scn.instance()
#	get_node("level").set_name("old")
#	level.set_name("level")
#	
#	level.active_units = units_vector
#	level.barracks_units = barracks
#	level.storage_weapons = storage_wpn
#	level.storage_items = storage_itm
#	add_child(level)
#	get_node("old").queue_free()
#	# Continue population weapons and items, need more details on unit maybe
