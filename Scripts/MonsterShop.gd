
extends Control

var BoxColumns = 3
var PageAmount = 15

var selected_id = -1

var shop_depo =  []

func _ready():
	# LEMBRAR QUE QUANDO FOR GERAR UM SHOP NOVO,
	# TEM QUE LIBERAR TODOS OS IDS NÃO UTILIZADOS
	var w_size = OS.get_window_size()
	get_node("Display").set_pos(Vector2(w_size.x - 425, 20))

func generate_shop():
	# Devera receber alguns argumentos que definam seu progresso no jogo.
	# Pode ser o rank na Arena, ou o número de dinheiro pago no débito.
	
	# O shop gerará uma nova seleção a cada dia (ou semana?), ainda baseada
	# em seu progresso. O número gerado também dependerá do progresso no
	# jogo.
	
	shop_depo.clear()

	for num in range (0, 3 + randi() % ((global.battle_progress + global.race_progress)) + global.month * global.year):
		
		var rand_grads = []
		for iter in range (0, 6):
			# Não pode dar nenhum monstro com gradação melhor que 4 antes do segundo ano
			var random_gradation = (randi() % ((global.battle_progress + global.race_progress) % (4 + global.year)))
			if (random_gradation > 6):
				random_gradation = 6
			rand_grads.append(random_gradation)
			
		g_monster.monster_generate(shop_depo, "nhi", Color(-1, -1, -1), rand_grads, [0], 3)

	for mon in shop_depo:
		var act = log(mon.stats[2])
		randomize()
		mon.acts = floor(rand_range(act - act/5, act + act/5))


func _on_Buy_pressed():
	var count = 0
	
	for monster in shop_depo:
		if monster.idn == selected_id:
			if (global.quesha < get_parent().calculate_price(monster)):
				global.instance_warning(self, "You can't pay for that")
				print("Not enough cash, stranger")
			else:
				global.handle_quesha(-get_parent().calculate_price(monster))
				
				global.mon_depo.append(monster)
				shop_depo.remove(count)
				
				get_node("Display").kill()
				get_node("SelectBox").clear_box()
				get_node("SelectBox").update_config(shop_depo, PageAmount, BoxColumns)
				get_node("SelectBox").generate_members()
				
				get_node("Buy").set_disabled(true)
				selected_id = -1
			
			break
		count += 1

func _on_Back_pressed():
	hide()
	get_node("Display").kill()
	get_node("SelectBox").kill()
	get_node("Buy").set_disabled(true)
	get_parent().get_node("VBox").show()
