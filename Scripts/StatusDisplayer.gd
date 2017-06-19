
extends Control


func gradate( grad ):
	if grad == 0:
		return "F"
	elif grad == 1:
		return "E"
	elif grad == 2:
		return "D"
	elif grad == 3:
		return "C"
	elif grad == 4:
		return "B"
	elif grad == 5:
		return "A"
	elif grad == 6:
		return "S"


func display(monster):
	display_personas(monster)

	get_node("Stats/STR").get_node("Gradation").set_text(str("STR ", gradate(monster.gradations[0])))
	get_node("Stats/STR").get_node("Value").set_text(str(monster.stats[0]))

	get_node("Stats/AGI").get_node("Gradation").set_text(str("AGI ", gradate(monster.gradations[1])))
	get_node("Stats/AGI").get_node("Value").set_text(str(monster.stats[1]))

	get_node("Stats/VIT").get_node("Gradation").set_text(str("VIT ", gradate(monster.gradations[2])))
	get_node("Stats/VIT").get_node("Value").set_text(str(monster.stats[2]))

	get_node("Stats/TEN").get_node("Gradation").set_text(str("TEN ", gradate(monster.gradations[3])))
	get_node("Stats/TEN").get_node("Value").set_text(str(monster.stats[3]))

	get_node("Stats/WIS").get_node("Gradation").set_text(str("WIS ", gradate(monster.gradations[4])))
	get_node("Stats/WIS").get_node("Value").set_text(str(monster.stats[4]))

	get_node("Stats/FER").get_node("Gradation").set_text(str("FER ", gradate(monster.gradations[5])))
	get_node("Stats/FER").get_node("Value").set_text(str(monster.stats[5]))


func display_personas(mon):
	var personas = ""
	var effects = ""
	
	for per in mon.personas:
		var name = personality_db.get_name(per)
		var skill = personality_db.get_skill(per)
		personas = str(personas, name, "\n")
		effects = str(effects, skill, "\n")
	
	get_node("Personalities").clear()
	get_node("Personalities").add_text(personas)
	get_node("Effects").clear()
	get_node("Effects").add_text(effects)


func kill():
	get_node("Stats/STR").get_node("Gradation").set_text("")
	get_node("Stats/STR").get_node("Value").set_text("")

	get_node("Stats/AGI").get_node("Gradation").set_text("")
	get_node("Stats/AGI").get_node("Value").set_text("")

	get_node("Stats/VIT").get_node("Gradation").set_text("")
	get_node("Stats/VIT").get_node("Value").set_text("")

	get_node("Stats/TEN").get_node("Gradation").set_text("")
	get_node("Stats/TEN").get_node("Value").set_text("")

	get_node("Stats/WIS").get_node("Gradation").set_text("")
	get_node("Stats/WIS").get_node("Value").set_text("")

	get_node("Stats/FER").get_node("Gradation").set_text("")
	get_node("Stats/FER").get_node("Value").set_text("")

	get_node("Personalities").clear()