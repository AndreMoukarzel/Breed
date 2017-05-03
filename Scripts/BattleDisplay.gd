extends Control


var mon = null


func display( monster ):
	if mon != null: # clears old sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = monster

	g_monster.monster_sprite(self, g_monster.get_id(mon.species), mon.color, Vector2(140, 150), Vector2(0.5, 0.5), true)

	set_info(0, "Hp")
	set_info(0, "Atk")
	set_info(0, "Spd")
	set_info(0, "Shrp")


func set_info(val, atri):
	var stat
	var color

	# actually use val instead of this shit
	if (atri == "Hp"):
		stat = mon.stats[2]
		color = Color(1, 1, 1)
	elif (atri == "Atk"):
		stat = mon.stats[0]
		color = Color(1, 1, 1)
	elif (atri == "Spd"):
		stat = mon.stats[1]
		color = Color(1, 1, 1)
	elif (atri == "Shrp"):
		stat = mon.stats[4]
		color = Color(1, 1, 1)
	else:
		print ("Incorrect atri in set_info")
		return

	get_node(str(atri, "/ProgressBar")).set_max(stat)
	get_node(str(atri, "/ProgressBar")).set_val(stat)
	get_node(str(atri, "/ProgressBar")).set_size(Vector2(stat * 3, 20))
	# set ProgressBar's color

	get_node(str(atri, "/Label")).set_text(str(stat))
	get_node(str(atri, "/Label")).set_pos(Vector2(stat * 3 + 60, get_node(str(atri, "/Label")).get_pos().y))
	# set label's pos to be next to bar (or inside it?)


func kill():
	if mon != null: # clears sprite
		get_node("Monster").set_name("old")
		get_node("old").queue_free()

	mon = null