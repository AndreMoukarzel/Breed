
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


func display( monster ):
	get_node("STR").get_node("Gradation").set_text(str("STR ", gradate(monster.gradations[0])))
	get_node("STR").get_node("Value").set_text(str(monster.stats[0]))

	get_node("AGI").get_node("Gradation").set_text(str("AGI ", gradate(monster.gradations[1])))
	get_node("AGI").get_node("Value").set_text(str(monster.stats[1]))

	get_node("VIT").get_node("Gradation").set_text(str("VIT ", gradate(monster.gradations[2])))
	get_node("VIT").get_node("Value").set_text(str(monster.stats[2]))

	get_node("TEN").get_node("Gradation").set_text(str("TEN ", gradate(monster.gradations[3])))
	get_node("TEN").get_node("Value").set_text(str(monster.stats[3]))

	get_node("WIS").get_node("Gradation").set_text(str("WIS ", gradate(monster.gradations[4])))
	get_node("WIS").get_node("Value").set_text(str(monster.stats[4]))

	get_node("FER").get_node("Gradation").set_text(str("FER ", gradate(monster.gradations[5])))
	get_node("FER").get_node("Value").set_text(str(monster.stats[5]))


func kill():
	get_node("STR").get_node("Gradation").set_text("")
	get_node("STR").get_node("Value").set_text("")

	get_node("AGI").get_node("Gradation").set_text("")
	get_node("AGI").get_node("Value").set_text("")

	get_node("VIT").get_node("Gradation").set_text("")
	get_node("VIT").get_node("Value").set_text("")

	get_node("TEN").get_node("Gradation").set_text("")
	get_node("TEN").get_node("Value").set_text("")

	get_node("WIS").get_node("Gradation").set_text("")
	get_node("WIS").get_node("Value").set_text("")

	get_node("FER").get_node("Gradation").set_text("")
	get_node("FER").get_node("Value").set_text("")