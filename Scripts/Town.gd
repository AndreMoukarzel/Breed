
extends Control

var count = 0

func _ready():
	print("Town")


func _on_ShopMonster_pressed():
	if( count >= 10 ):
		print("Ja deu de assedio seu doente")
	else:
		print("moomoo")

	count += 1


func _on_Back_pressed():
	self.hide()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()

	count = 0