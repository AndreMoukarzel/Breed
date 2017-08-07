
extends Control

var shop_depo =  []

func _ready():
	# LEMBRAR QUE QUANDO FOR GERAR UM SHOP NOVO,
	# TEM QUE LIBERAR TODOS OS IDS NÃO UTILIZADOS
	generate_shop()

func generate_shop():
	# Devera receber alguns argumentos que definam seu progresso no jogo.
	# Pode ser o rank na Arena, ou o número de dinheiro pago no débito.
	
	# O shop gerará uma nova seleção a cada dia (ou semana?), ainda baseada
	# em seu progresso. O número gerado também dependerá do progresso no
	# jogo.

	for num in range (0, 45):
		# Gera o catalisador, e coloca no deposito
		var randomstats = []
		for n in range (0, 7):
			randomstats.append(randi() % 100)
		global.append_catal(shop_depo, global.Catal.new(g_monster.get_species(randi() % 3), randomstats), 1)


func _on_Buy_pressed():
	var amount = get_node("CatalystBox/AmountChooser").amount
	
	get_parent().cat.sort()
	get_parent().cat.invert()
	
	
	var price = 0
	for c in get_parent().cat:
		price += shop_depo[c][0].level * 100 * min(amount, shop_depo[c][1])
	
	if (global.quesha < price):
		global.instance_warning(self, "You can't pay for that")
		print("Not enough cash, stranger")
	else:
		global.handle_quesha(-price)
		
		for c in get_parent().cat:
			global.append_catal(global.catal_depo, shop_depo[c][0], min(amount, shop_depo[c][1]))
			
			shop_depo[c][1] -= amount
			if (shop_depo[c][1] <= 0):
				shop_depo.remove(c)
		
		get_node("CatalystBox").clear_box()
		get_node("CatalystBox").generate_members()
		
		get_node("Buy").set_disabled(true)
		
		get_parent().cat.clear()
		get_node("CatalystBox/AmountChooser").amount = 1
		get_node("CatalystBox/AmountChooser").hide()

func _on_Back_pressed():
	hide()
	get_parent().cat.clear()
	get_node("CatalystBox/AmountChooser").amount = 1
	get_node("CatalystBox/AmountChooser").hide()
	get_parent().get_node("VBox").show()
	
	get_node("CatalystBox").clear_box()