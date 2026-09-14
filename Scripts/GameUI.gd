extends Control

# ---------- VARIABLES ---------- #

@onready var coinsLabel = $CoinsLabel
@onready var thankYouLabel = $ThankYouLabel

# ---------- FUNCTIONS ---------- #

func _ready():
	thankYouLabel.visible = false
	GameManager.all_coins_collected.connect(_on_all_coins_collected)

func _process(_delta):
	coinsLabel.text = "x %d" % GameManager.score # Set the coin label text to the score variable

func _on_all_coins_collected():
	thankYouLabel.visible = true
