
extends Control

var BoxColumns = 3
var PageAmount = 12

var shop_depo =  []

func _ready():
	generate_shop()

func generate_shop():
	# Devera receber alguns argumentos que definam seu progresso no jogo.
	# Pode ser o rank na Arena, ou o número de dinheiro pago no débito.
	
	# O shop gerará uma nova seleção a cada dia (ou semana?), ainda baseada
	# em seu progresso. O número gerado também dependerá do progresso no
	# jogo.

	for num in range (0, 12):
		get_parent().get_parent().monster_generate(shop_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 3)
	
