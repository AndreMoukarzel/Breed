extends Control

# Na hora de settar o nome do catalyst, ele será o nome da espécie,
# concatenado com o refino dele (I, II, III, IV, ...)

# falta a parte visual

func set_info(catalyst):
	var catal = catalyst

	get_node("Name").set_text(str(catal[0].species, " ", catal[0].level))
	get_node("Name").show()

	get_node("Quantity").set_text(str(catal[1]))
	get_node("Quantity").show()

	# Missing catalyst icon

func _on_Button_pressed():
	# tem que fazer tudo ignorar o mouse menos as opções novas (sim ou não de usar o catalisador)
	# get_node("Button").set_ignore_mouse(true)
	# funcionalidade que coloca o sim/não e desabilita tudo pode vir ai
	get_parent().button_pressed(self)