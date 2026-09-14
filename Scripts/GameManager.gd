extends Node3D

# ---------- SIGNALS ---------- #

signal all_coins_collected

# ---------- VARIABLES ---------- #

var score = 0
var total_coins = 0

# Ordered list of levels. After the coins in one level are all collected,
# the game automatically loads the next scene in this list.
# Add more scene paths here to extend the game with more levels.
var levels = [
	"res://Scenes/demo_scene.tscn",
	"res://Scenes/demo_scene2.tscn"
]
var current_level_index = 0

# ---------- FUNCTIONS ---------- #

func _ready():
	# Wait one frame so all coins in the level have entered the "Coin" group first
	call_deferred("_count_total_coins")

func _process(_delta):
	show_mouse_cursor()

func _count_total_coins():
	total_coins = get_tree().get_nodes_in_group("Coin").size()

# Making Cursor visible using "mouse_visible" key which is assigned in Project Settings > Input Map
func show_mouse_cursor():
	if Input.is_action_just_pressed("mouse_visible"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func add_score():
	score += 1
	if total_coins > 0 and score >= total_coins:
		_on_level_cleared()

# Called once every coin in the current level has been collected.
func _on_level_cleared():
	if current_level_index < levels.size() - 1:
		# There is another level queued up -> go straight to it
		current_level_index += 1
		_go_to_level(levels[current_level_index])
	else:
		# This was the last level -> tell the UI to show the Thank You screen
		all_coins_collected.emit()

# Loads the given scene and resets score/coin tracking for it.
func _go_to_level(path: String) -> void:
	get_tree().change_scene_to_file(path)
	# Wait a couple of frames so the new scene's nodes (and its coins) are
	# fully ready before we recount them.
	await get_tree().process_frame
	await get_tree().process_frame
	score = 0
	_count_total_coins()
