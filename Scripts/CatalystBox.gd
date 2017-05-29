extends Control

var boxunit_scn = preload("res://Scenes/CatalystBoxUnit.tscn")

# A caixa será de tamanho fixo, com diversas páginas

# Quando pressionar botão, ele trava o botão e todo o resto da caixa e etc e pergunta
# se você quer usar este catalisador. Na hora de pressionar o botão guardamos o valor, e
# o botão pode ter toggle_mode = true para facilitar, e clicando sim ou não, não importa, usa o button.press()
# e foda-se

# Box = CatalystBoxUnit
var box_size = Vector2(225, 150)
var box_scale = Vector2(0.75, 0.75)

var mon_index = -1 #The index of the monster in the mon_depo
var catal_index = -1 #The index of selected catalyst in the catal_depo

var page = 0 # displayed page
var page_amount = 20
var max_cols = 5
var max_pages = 0

# Os catalisadores ficam guardados em global.catal_depo

func create(m_id):
	update_config(m_id)
	generate_members()


func update_config(m_id):
	# Sizes will be fixed, but we call a script so we can manage
	# positioning by code.
	var w_size = OS.get_window_size()
	var size = box_size * box_scale
	var bg = get_node("Background")
	var spacing = w_size.x - (max_cols * size.x)
	
	set_pos(Vector2(spacing/2, 40))
	bg.set_scale(Vector2(w_size.x/1920, w_size.y/1080))
	bg.set_pos(Vector2(-spacing/2, -40))

	mon_index = m_id
	max_pages = int(ceil(float(global.catal_depo.size()) / page_amount))
	
	# Position page managing arrows and text acording to new config
	var size = box_size * box_scale
	var Fp = get_node("FowardPage")
	var Bp = get_node("BackPage")
	var Pd = get_node("PageDisplay")
	var R = get_node("Return")
	var Y = get_node("Yes")
	var N = get_node("No")
	
	Fp.set_pos(Vector2((size.x * max_cols) - Fp.get_size().x - 10, (size.y * page_amount / max_cols) + 10))
	Bp.set_pos(Vector2(10, (size.y * page_amount / max_cols) + 10))
	Pd.set_pos(Vector2((size.x * max_cols)/2 - Pd.get_size().x/2, (size.y * page_amount / max_cols) + 10))
	R.set_pos(Vector2((size.x * max_cols)/2 - R.get_size().x/2, (size.y * page_amount / max_cols) + 50))
	Y.set_pos(Vector2((size.x * max_cols)/2 - Y.get_size().x/2 - 100, (size.y * page_amount / max_cols) + 50))
	N.set_pos(Vector2((size.x * max_cols)/2 - N.get_size().x/2 + 100, (size.y * page_amount / max_cols) + 50))
	
	if (global.catal_depo.size() == 0):
		Pd.set_text("1/1")
	else:
		Pd.set_text(str(page + 1, "/", max_pages))

	# Special case
	if (max_pages <= 1):
		Fp.set_disabled(true)
		Bp.set_disabled(true)
	else:
		Fp.set_disabled(false)
		Bp.set_disabled(false)

# Create page_amount CatalystBoxUnit, filling them acordingly 
func generate_members():
	var s_count = 0 # spacing counter
	var size = box_size * box_scale

	for num in range (page * page_amount, (page + 1) * page_amount):
		var newunit = boxunit_scn.instance()
		newunit.set_name(str(num))

		if (global.catal_depo.size() <= num):
			newunit.get_node("Button").set_disabled(true)
			#this is new
			newunit.get_node("Button").set_ignore_mouse(true)
		else:
			var catal = global.catal_depo[num]
			newunit.set_info(catal)
			# Aqui geramos a parte visual de cada unidade do catalisador.
			# Essencialmente, colocar a sprite para cada um, e escrever nas
			# labels.
			
			#g_monster.monster_sprite(newunit, g_monster.get_id(mon.species), mon.color, Vector2(50,90), Vector2(0.15, 0.15), false)
			#newunit.set_info(mon)

		newunit.set_pos(Vector2(size.x * (s_count % max_cols), size.y * floor(s_count / max_cols)))
		newunit.set_scale(Vector2(0.75, 0.75))
		s_count += 1
		add_child(newunit)
		
func clear_box():
	for num in range(page * page_amount, (page + 1) * page_amount):
		get_node(str(num)).set_name(str("old", get_node(str(num)).get_name()))
		get_node(str("old", num)).queue_free()


func kill():
	# Precisa esquecer o ultimo catalisador selecionado, talvez
	clear_box()
	page = 0
	
####### BUTTON FUNCIONALITY #######

func button_pressed(body):
	# Precisa travar tudo, etc etc (funcionalidade descrita em comentarios superiores tanto
	# deste script, como dos botões). O monstro em qual será aplicado é obtido pelo index
	# (os catalisadores são aplicáveis apenas em monstros do jogador, e o mon_depo é global).
	
	# Ou seja, trava tudo, libera as opções de "SIM" e "NÃO" e deixa a responsabilidade de aplicar
	# os efeitos para estes botões.
	
	# Lembrando que tem que checar se o monstro ja tomou o catalisador na hora de apertar "SIM"
	
	catal_index = body.get_name().to_int()
	
	toggle_mouse_interaction(true)
	get_node("Yes").show()
	get_node("No").show()
	
func toggle_mouse_interaction(tog):
	get_node("FowardPage").set_ignore_mouse(tog)
	get_node("BackPage").set_ignore_mouse(tog)
	get_node("Return").set_ignore_mouse(tog)
	for num in range(page * page_amount, (page + 1) * page_amount):
		get_node(str(num)).get_node("Button").set_ignore_mouse(tog)
		# get_node(str(num)).set_block_signals(true) (para o OffspringWindow)

func _on_BackPage_pressed():
	if (global.catal_depo.size() != 0):
		clear_box()
		
		page -= 1
		if (page < 0):
			page = max_pages - 1
		
		# Adjustments
		get_node("PageDisplay").set_text(str(page + 1, "/", max_pages))
	
		generate_members()


func _on_FowardPage_pressed():
	if (global.catal_depo.size() != 0):
		clear_box()
		
		page = (page + 1) % max_pages
		
		# Adjustments
		get_node("PageDisplay").set_text(str(page + 1, "/", max_pages))

		generate_members()


func _on_Return_pressed():
	queue_free()

func _on_Yes_pressed():
	# Precisa checar se o monstro ja consumiu um catalisador antes
	# de permitir o consumo do selecionado.
	# Tem que resetar a caixa em caso de consumo, e checar se a quantidade
	# do catalisador selecionado chegou a zero, para remove-lo do vetor.
	
	if (global.mon_depo[mon_index].catal_boosts.size() == 0):
		# [[max1, max2], [min1, min2]]
		# A ESPECIE É DO CATAL, NAO DO MONSTRO
		var prom_vec = g_monster.determine_prominent_stats(global.catal_depo[catal_index][0].species)
		var boost_quantity
		# Soma os boosts dos dois status maiores da especie do catalisador, vezes o level
		for stat_id in prom_vec[0]:
			boost_quantity = floor(global.mon_depo[mon_index].stats[stat_id] * 0.1 * global.catal_depo[catal_index][0].level)
			
			global.mon_depo[mon_index].catal_boosts.append([boost_quantity, stat_id])
			global.mon_depo[mon_index].stats[stat_id] += boost_quantity
			
		# Subtrai os boosts dos dois status maiores da especie do catalisador, vezes o level
		for stat_id in prom_vec[1]:
			boost_quantity = -floor(global.mon_depo[mon_index].stats[stat_id] * 0.1 * global.catal_depo[catal_index][0].level)
			
			global.mon_depo[mon_index].catal_boosts.append([boost_quantity, stat_id])
			global.mon_depo[mon_index].stats[stat_id] += boost_quantity
		
		#test
		print(global.mon_depo[mon_index].catal_boosts)
		
		# Decrementa catalisador utilizado, reloada a caixa
		global.catal_depo[catal_index][1] -= 1
		if (global.catal_depo[catal_index][1] == 0):
			global.catal_depo.remove(catal_index)
		clear_box()
		generate_members()
		
		# Atualiza o display
		if (get_parent().blue != 0):
			get_parent().get_node("Display1").display(global.mon_depo[mon_index])
		else:
			get_parent().get_node("Display2").display(global.mon_depo[mon_index])
		
	else:
		# Already used catal message
		print ("BOQUINHA GULOSA")
	
	toggle_mouse_interaction(false)
	get_node("Yes").hide()
	get_node("No").hide()

func _on_No_pressed():
	toggle_mouse_interaction(false)
	get_node("Yes").hide()
	get_node("No").hide()
	for num in range(page * page_amount, (page + 1) * page_amount):
		get_node(str(num)).get_node("Button").set_pressed(false)
