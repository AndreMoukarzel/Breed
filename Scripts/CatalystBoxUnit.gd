extends Control

# Na hora de settar o nome do catalyst, ele será o nome da espécie,
# concatenado com o refino dele (I, II, III, IV, ...)

# falta a parte visual

func _on_Button_pressed():
	# tem que fazer tudo ignorar o mouse menos as opções novas (sim ou não de usar o catalisador)
	# get_node("Button").set_ignore_mouse(true)
	# funcionalidade que coloca o sim/não e desabilita tudo pode vir ai
	get_parent().button_pressed(self)