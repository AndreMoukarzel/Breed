extends Control

onready var farmer = get_node("AnimatedSprite")

var time = 0
var retime = 1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	if (time > 4):
		var rn = randi() % 3
		if (rn == 0):
			print(farmer.get_pos().x)
			if (farmer.get_pos().x - 20 > -70):
				get_node("AnimatedSprite").play("WalkLeft")
				get_node("AnimatedSprite/Tween").interpolate_property(farmer, "transform/pos", farmer.get_pos(), farmer.get_pos() + Vector2(-(randi() % 20), 0), rand_range(1.5, 2.5), Tween.TRANS_LINEAR, Tween.EASE_OUT)
				get_node("AnimatedSprite/Tween").start()
				set_fixed_process(false)
				yield(get_node("AnimatedSprite/Tween"), "tween_complete")
				set_fixed_process(true)
				get_node("AnimatedSprite").play("Idle")
		elif (rn == 1):
			print(farmer.get_pos().x)
			if (farmer.get_pos().x + 20 < 70):
				get_node("AnimatedSprite").play("WalkRight")
				get_node("AnimatedSprite/Tween").interpolate_property(farmer, "transform/pos", farmer.get_pos(), farmer.get_pos() + Vector2(randi() % 20, 0), rand_range(1.5, 2.5), Tween.TRANS_LINEAR, Tween.EASE_OUT)
				get_node("AnimatedSprite/Tween").start()
				set_fixed_process(false)
				yield(get_node("AnimatedSprite/Tween"), "tween_complete")
				set_fixed_process(true)
				get_node("AnimatedSprite").play("Idle")
		elif (rn == 2):
			get_node("AnimatedSprite").play("Greet")
		
		retime = randi() % 10
		time = 0
			