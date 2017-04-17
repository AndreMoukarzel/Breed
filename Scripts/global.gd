extends Node

const MAX_ENERGY = 3000

var ID = 0
var free_ids = []

var kesha = 0

var month = 0
var days = 0
# Given in minutes. A day has 1440 minutes
#var time = 0

# Maximum energy value is fixed, for now
var energy = MAX_ENERGY

var mon_depo = []

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


func goto_scene(path):

    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):

    # Immediately free the current scene,
    # there is no risk here.
	current_scene.free()

    # Load new scene
	var s = ResourceLoader.load(path)

    # Instance the new scene
	current_scene = s.instance()

    # Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )


func get_id():
	if free_ids.empty():
		ID += 1
		return ID - 1

	return free_ids.pop_front()
	
# Adds the value passed to the function to the energy
func handle_energy(val):
	var path = get_tree().get_root().get_node("GameMenu/HUD/Energy")
	energy += val
	if (energy < 0):
		energy = 0
	if (energy > MAX_ENERGY):
		energy = MAX_ENERGY
	path.set_value(energy)
	path.get_node("EnergyLabel").set_text(str(energy))
	
#func handle_time(val):
#	var path = get_tree().get_root().get_node("GameMenu/HUD/DateAndTime/Time")
#	var hours
#	var minutes
#	
#	time += val
#	hours = floor(time / 60)
#	minutes = time % 60
#	
#	if (hours >= 10 and minutes >= 10):
#		path.set_text(str(hours, ":", minutes))
#	elif (hours < 10 and minutes >= 10):
#		path.set_text(str("0", hours, ":", minutes))
#	elif (hours >= 10 and minutes < 10):
#		path.set_text(str(hours, ":0", minutes))
#	else:
#		path.set_text(str("0", hours, ":0", minutes))


func handle_days(val):
	var day_path = get_tree().get_root().get_node("GameMenu/HUD/DateAndTime/Date")
	
	# Updates day
	days += val
	if (days > 30):
		month += 1
		days = 1
	handle_energy(MAX_ENERGY)
	day_path.set_text(str(days, " X ", month))

	# Updates catals and actions in monsters
	for mon in mon_depo:
		mon.catal[0] += mon.acts
		if (mon.catal[0] > mon.catal[1]):
			mon.catal[0] = 0

		var act = log(mon.stats[2])
		randomize()
		mon.acts = floor(rand_range(act - act/5, act + act/5))