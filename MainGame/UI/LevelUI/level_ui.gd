extends CanvasLayer

var main 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_info = main.get_node("PlaceHolderPlayer")
	$LevelUI/HeartsCounter.text = "Hearts x" + str(player_info.get_meta('PlayerInfo').health)
	$LevelUI/CharacterHealthInfo/LivesCounter.text = "x" + str(player_info.get_meta('PlayerInfo').lives)
	$LevelUI/ScoreLabel.text = "Score " + str(GlobalStuff.score)
	$LevelUI/CoinsCounter.text = str(GlobalStuff.coins) + " Coins"
