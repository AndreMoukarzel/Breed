
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

var id1 = null
var id2 = null

func _ready():
	get_node("Storage1").set_pos(Vector2(20 - get_node("Storage1/StorageBackground1").get_size().x, 45))
	get_node("Storage2").set_pos(Vector2(OS.get_window_size().x - 20, 45))


func update_boxes():
	Sbox1.update_config(global.mon_depo, PageAmount, BoxColumns)
	Sbox1.generate_members()
	
	Sbox2.update_config(global.mon_depo, PageAmount, BoxColumns)
	Sbox2.generate_members()
	
func update_boxes_and_hide_display():
	
	get_node("Display1").kill()
	get_node("Display1/Collect1").hide()
	get_node("Display1/Feed1").hide()
	get_node("Display2").kill()
	get_node("Display2/Collect2").hide()
	get_node("Display2/Feed2").hide()
	
	update_boxes()


func mon_select_update():
	if (id1 == null or id2 == null):
		print("wtf man")
		return

	var pg1 = floor(id1/ Sbox1.page_amount)
	var pg2 = floor(id2/ Sbox2.page_amount)

	Sbox1.page = int(pg1)
	Sbox2.page = int(pg2)
	update_boxes()
	Sbox1.press_button(str(id1))
	Sbox2.press_button(str(id2))


func select_monster( monster, select_box ):
	var origin = select_box.get_parent().get_name()

	if( origin == "Storage1" ):
		get_node("Display1").kill_animation()
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
		get_node("Display2").kill_animation()
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
	if blue:
		_on_StorageBackground1_pressed()
	elif red:
		_on_StorageBackground2_pressed()
	
	# Positions in array mon_depo
	id1 = null
	id2 = null
	# Actual monster class instances
	var m1 = null
	var m2 = null

	if (mon1 == -1 or mon2 == -1):
		global.instance_warning(self, "Select two monsters")
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
		global.instance_warning(self, str(m1.name, " has no action points"))
		print (str(m1.name, " has no action points"))
		return
	if (m2.acts == 0):
		global.instance_warning(self, str(m2.name, " has no action points"))
		print (str(m2.name, " has no action points"))
		return

	Sbox1.clear_box()
	Sbox2.clear_box()

	var script = load("res://Scripts/Breeding.gd").new()
	script.set_name("TempBreeding")
	add_child(script)
	script.breed(m1, m2, self)
	
	get_node("TempBreeding").queue_free()

	set_breed_info(mon1, mon2)
	mon_select_update()
	
	# For level up animation's sake
	if (get_node("Display1/StatusDisplayer").has_node("LevelUpAnimTemporary")):
		get_node("Display1/StatusDisplayer/LevelUpAnimTemporary").set_name("LevelUpAnim")
	if (get_node("Display2/StatusDisplayer").has_node("LevelUpAnimTemporary")):
		get_node("Display2/StatusDisplayer/LevelUpAnimTemporary").set_name("LevelUpAnim")


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

	get_parent().get_node("Buttons").show()
	get_parent().get_node("Farmer").show()
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
		global.instance_warning(self, str(monster.name, " needs to rest"))
		print(str(monster.name, " has no strength left in its pipi"))
		return 

	if monster.catal[0] > 0:
		global.append_catal(global.catal_depo, global.Catal.new(monster.species, monster.stats), monster.catal[0])

		monster.catal[0] = 0
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
		global.instance_warning(self, str(monster.name, " needs to rest"))
		print(str(monster.name, " has no strength left in its pipi"))
		return 

	if monster.catal[0] > 0:
		global.append_catal(global.catal_depo, global.Catal.new(monster.species, monster.stats), monster.catal[0])

		monster.catal[0] = 0
		monster.acts = 0

	Sbox1.clear_box()
	Sbox2.clear_box()
	update_boxes()


func _on_Feed1_pressed():
	# Search for monster position on mon_depo
	var v_id = -1
	for i in range(global.mon_depo.size()):
		if (global.mon_depo[i].idn == mon1):
			v_id = i
			break
	
	if (v_id != -1):
		var feeding_display_scn = load("res://Scenes/CatalystBox.tscn")
		var display = feeding_display_scn.instance()
		add_child(display)
		display.create(global.catal_depo, v_id)


func _on_Feed2_pressed():
	# Search for monster position on mon_depo
	var v_id = -1
	for i in range(global.mon_depo.size()):
		if (global.mon_depo[i].idn == mon2):
			v_id = i
			break
	
	if (v_id != -1):
		var feeding_display_scn = load("res://Scenes/CatalystBox.tscn")
		var display = feeding_display_scn.instance(v_id)
		add_child(display)
		display.create(global.catal_depo, v_id)


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

	# Chance of having child
	var chance
	if ((m1.gender == 0 and m2.gender == 0) or (m1.gender == 1 and m2.gender == 1)):
		chance = 0
	else:
		chance = floor(log((m1.stats[5] + m2.stats[5])/2) * 6)
		if (m1.last_breed == m2 or m2.last_breed == m1):
			chance += m1.bonus_preg
	
	# Apply bonus chance from fertility personality
	for persona in m1.personas:
		if personality_db.get_types(persona)[0] == "BF":
			chance = floor(chance * 1.1)
	for persona in m2.personas:
		if personality_db.get_types(persona)[0] == "BF":
			chance = floor(chance * 1.1)

	# Action cost
	var cost = 2000 - floor((m1.stats[2] + m2.stats[2])/2 * 130)
	
	# Check incest
	var incest = 0
	if (m1.parent1_idn != null and m2.parent1_idn != null):
		if (m1.parent1_idn == m2.parent1_idn or m1.parent1_idn == m2.parent2_idn):
			incest = 1
		elif (m1.parent2_idn == m2.parent1_idn or m1.parent2_idn == m2.parent2_idn):
			incest = 1
	if (m1.idn == m2.parent1_idn or m1.idn == m2.parent2_idn):
		incest = 2
	elif (m2.idn == m1.parent1_idn or m2.idn == m1.parent2_idn):
		incest = 2
	print(str("Incest: ", incest))

	info.get_node("PregChance").set_text(str(chance, "%"))
	info.get_node("Cost").set_text(str("Cost:\n", cost))
	var breed_btn = get_node("Breed")
	if incest == 0:
		breed_btn.set_normal_texture(load("res://Resources/Sprites/GUI/Barn/breed1.png"))
		breed_btn.set_hover_texture(load("res://Resources/Sprites/GUI/Barn/breed2.png"))
		breed_btn.set_pressed_texture(load("res://Resources/Sprites/GUI/Barn/breed3.png"))
	elif incest == 1:
		breed_btn.set_normal_texture(load("res://Resources/Sprites/GUI/Barn/breed1incest1.png"))
		breed_btn.set_hover_texture(load("res://Resources/Sprites/GUI/Barn/breed2incest1.png"))
		breed_btn.set_pressed_texture(load("res://Resources/Sprites/GUI/Barn/breed3incest1.png"))
	elif incest == 2:
		breed_btn.set_normal_texture(load("res://Resources/Sprites/GUI/Barn/breed1incest2.png"))
		breed_btn.set_hover_texture(load("res://Resources/Sprites/GUI/Barn/breed2incest2.png"))
		breed_btn.set_pressed_texture(load("res://Resources/Sprites/GUI/Barn/breed3incest2.png"))