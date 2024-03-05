extends Node

var PlayerHealth : int = 100
var PlayerMaxHealth : int = 100
var PlayerPosition : int = 0
var PlayerPath : int = 0
var PlayerDamage : int = 10
var PlayerMaxOverdrive : int = 100
var PlayerOverdrive : int = 0
var Streak : int = 0
var Ankh : bool = false
var Blade : bool = false
var Orb : bool = false
var WeakenSpell : bool = false
var AskedQuestions : Array = []
var FoughtEnemies : Array = []

var db : SQLite = null
var question_array_easy : Array = []
var question_array_medium : Array = []
var question_array_hard : Array = []

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]

func set_overdrive(progress_bar, overdrive, max_overdrive):
	progress_bar.value = overdrive
	progress_bar.max_value = max_overdrive
	progress_bar.get_node("Label").text = "%d/%d" % [overdrive, max_overdrive]

func reset():
	PlayerHealth = 100
	PlayerMaxHealth = 100
	PlayerPosition = 0
	PlayerPath = 0
	PlayerDamage = 10
	PlayerMaxOverdrive = 100
	PlayerOverdrive = 0
	Streak = 0
	Ankh = false
	Blade = false
	Orb = false
	WeakenSpell = false
	AskedQuestions = []
	FoughtEnemies = []

	db = null

	question_array_easy = []
	question_array_medium = []
	question_array_hard = []
func fetch_random_questions(difficulty: String, num_questions: int):
	# Open the database connection
	db = SQLite.new()
	db.path = "res://Assets/trivia.db"
	db.open_db()
	var select_query = "SELECT * FROM trivia WHERE difficulty = ? ORDER BY RANDOM() LIMIT ?"
	db.query_with_bindings(select_query, [difficulty, num_questions])
	var result = db.query_result
	db.close_db()
	return result
