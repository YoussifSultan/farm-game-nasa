extends Node2D

var date
var data
var soil_type
var crop_stage = "Mid"
var selected_country
var number_of_weeks = 0
@onready var nextweek_btn = get_node("UI/top_right/next_week_btn") # Replace with the actual path to your button
var crop_scorer = preload("res://scenes/game_scoring.gd").new()



func _on_soil_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$UI/soil_management.show()
	pass # Replace with function body.
	


func _on_ready() -> void:
	start_game()
	nextweek_btn.pressed.connect(onlick_nextweek)
	var button = get_node("UI/soil_management/Button")  # adjust path to your button
	button.pressed.connect(_on_button_pressed)
	

func _on_button_pressed():
	
	var crop = "potato"
	if $"UI/soil_management/crop chooser/carrot3".focus_entered:
		crop = "carrot"
		
	var fertilizer = $"UI/soil_management/MarginContainer/VBoxContainer/HBoxContainer2/fertilizer".value
	var water = $"UI/soil_management/MarginContainer/VBoxContainer/HBoxContainer/water".value
	var pesticide = $"UI/soil_management/MarginContainer/VBoxContainer/HBoxContainer3/pesticide".selected
	var control = "Chemical"
	var harvest_time = "Early"
	if pesticide == 1:
		control = "Eco"
	if(number_of_weeks > 6 ):
		harvest_time = "Late"
	
	var soil_N = crop_scorer.get_soil_N(soil_type)
	var date_str = convert_date_to_string(date)

	#print(data["GWETTOP"][date_str]*100,data["QV2M"][date_str]*100,data["T2M"][date_str],water,soil_N,soil_type,fertilizer,crop_stage,control,harvest_time)
	var result = crop_scorer.calculate_crop_scores(data["GWETTOP"][date_str]*100,data["QV2M"][date_str]*100, data["T2M"][date_str],water, soil_N, soil_type, fertilizer, crop_stage, control, harvest_time)
# Combine all parameters + results into a dictionary
	var game_round_entry = {
	"week_No" : number_of_weeks,
	"Soil Moisture": data["GWETTOP"][date_str]*100,
	"Humidity": data["QV2M"][date_str]*100,
	"Temperature": data["T2M"][date_str],
	"water": water,
	"soil_N": soil_N,
	"soil_type": soil_type,
	"fertilizer": fertilizer,
	"crop_stage": crop_stage,
	"control": control,
	"harvest_time": harvest_time,
	"crop": crop,
	"crop_quality": result["crop_quality"],
	"crop_quantity": result["crop_quantity"],
	"environment_score": result["environment_score"]
}

# Append to the game rounds list
	GlobalVariables.game_rounds.append(game_round_entry)

	$"UI/soil_management".hide()
	var dialog_working: bool = false
	var dialog_finished: bool = false
	var DIALOG_LINES =[]
	for tip in result["tips"]:
		DIALOG_LINES.append({"speaker": "The game", "text": tip},)	
	dialog_working = true
	await $UI/Dialogbox.start_dialog(DIALOG_LINES)
	dialog_working = false
	dialog_finished = true   # prevent repeat
	if(number_of_weeks >=8):
		end_game();
func display_game_rounds(entries: Array):
	# Assuming $GridContainer exists in your scene
	var grid = $UI/end_game/GridContainer
	
	# Clear previous children
	for child in grid.get_children():
		child.queue_free()
	
	# If entries exist
	if entries.size() == 0:
		return
	
	# Set columns to number of keys in dictionary
	grid.columns = entries[0].keys().size()
	
	# Add header labels
	for key in entries[0].keys():
		var label = Label.new()
		label.text = str(key)

		grid.add_child(label)
	
	# Add each row
	for entry in entries:
		for value in entry.values():
			var label = Label.new()
			label.text = str(value)
			grid.add_child(label)

func end_game():
	$"UI/end_game".show()
	display_game_rounds(GlobalVariables.game_rounds)
func onlick_nextweek():
	date = add_days_to_date(date, 7)
	get_data(convert_date_to_string(date),selected_country.lat,selected_country.long)
class Country:
	var name: String
	var long: float
	var lat: float

	func _init(name: String, long: float, lat: float):
		self.name = name
		self.long = long
		self.lat = lat

var countries_data = [
	Country.new("United States", -98.583333, 39.833333),
	Country.new("Canada", -106.346771, 56.130366),
	Country.new("Mexico", -102.552784, 23.634501),
	Country.new("Brazil", -51.92528, -14.235004),
	Country.new("Argentina", -63.616672, -38.416097),
	Country.new("United Kingdom", -3.435973, 55.378051),
	Country.new("France", 2.213749, 46.227638),
	Country.new("Germany", 10.451526, 51.165691),
	Country.new("Italy", 12.56738, 41.87194),
	Country.new("Spain", -3.74922, 40.463667),
	Country.new("Russia", 96.6890, 61.52401),
	Country.new("China", 104.195397, 35.86166),
	Country.new("Japan", 138.252924, 36.204824),
	Country.new("South Korea", 127.766922, 35.907757),
	Country.new("India", 78.96288, 20.593684),
	Country.new("Australia", 133.775136, -25.274398),
	Country.new("New Zealand", 174.885971, -40.900557),
	Country.new("South Africa", 24.991639, -29.046185),
	Country.new("Egypt", 30.802498, 26.820553),
	Country.new("Nigeria", 8.675277, 9.081999),
	Country.new("Kenya", 37.906193, -0.023559),
	Country.new("Saudi Arabia", 45.079162, 23.885942),
	Country.new("United Arab Emirates", 54.3773, 23.4241),
	Country.new("Turkey", 35.243322, 38.963745),
	Country.new("Iran", 53.688046, 32.427908),
	Country.new("Greece", 21.824312, 39.074208),
	Country.new("Portugal", -8.224454, 39.399872),
	Country.new("Sweden", 18.643501, 60.128161),
	Country.new("Norway", 8.468946, 60.472024),
	Country.new("Denmark", 9.501785, 56.26392),
	Country.new("Finland", 25.748151, 61.92411),
	Country.new("Poland", 19.145136, 51.919438),
	Country.new("Netherlands", 5.291266, 52.132633),
	Country.new("Belgium", 4.469936, 50.503887),
	Country.new("Switzerland", 8.227512, 46.818188),
	Country.new("Austria", 14.550072, 47.516231),
	Country.new("Czech Republic", 15.472962, 49.817492),
	Country.new("Hungary", 19.503304, 47.162494),
	Country.new("Romania", 24.96676, 45.943161),
	Country.new("Thailand", 100.992541, 15.870032),
	Country.new("Vietnam", 108.277199, 14.058324),
	Country.new("Indonesia", 113.921327, -0.789275),
	Country.new("Philippines", 121.774017, 12.879721),
	Country.new("Malaysia", 101.975766, 4.210484),
	Country.new("Singapore", 103.851959, 1.29027),
	Country.new("Pakistan", 69.345116, 30.375321),
	Country.new("Bangladesh", 90.356331, 23.684994),
	Country.new("Ukraine", 31.16558, 48.379433),
	Country.new("Chile", -71.542969, -35.675147),
]
func convert_date_to_string(date: Dictionary) -> String:
	var month = str(date.month)
	if month.length() == 1:
		month = "0" + month
	var day = str(date.day)
	if day.length() == 1:
		day = "0" + day
	return str(date.year) + month + day

func random_date(start: Dictionary, end: Dictionary) -> Dictionary:
	# Convert dictionaries into actual Time objects
	var start_unix = Time.get_unix_time_from_datetime_dict(start)
	var end_unix = Time.get_unix_time_from_datetime_dict(end)

	var random_unix = randi_range(start_unix, end_unix)
	return Time.get_datetime_dict_from_unix_time(random_unix)

func get_data(date: String, lat: float, lon: float) -> void:
	var url = "https://power.larc.nasa.gov/api/temporal/daily/point"
	url += "?parameters=T2M,RH2M,WS2M,WD2M,PRECTOTCORR,GWETTOP,IMERG_PRECTOT,GWETPROF,QV2M"
	url += "&community=ag"
	url += "&latitude=%s&longitude=%s" % [str(lat), str(lon)]
	url += "&start=%s&end=%s" % [date, date]
	url += "&format=JSON"

	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var err = http_request.request(url)
	if err != OK:
		push_error("HTTP Request error: %s" % err)

func start_game():
	randomize()
	selected_country = countries_data[randi() % countries_data.size()]
	var soil_types = ["Sandy", "Loamy", "Clay"]
	soil_type = soil_types[randi() % soil_types.size()]

	var start_date = {"year": 2000, "month": 1, "day": 1}
	var end_date = subtract_days_from_date(Time.get_datetime_dict_from_system(),365)
	date = random_date(start_date, end_date)
	var date_str = convert_date_to_string(date)
	get_data(date_str, selected_country.lat, selected_country.long)
	
func subtract_days_from_date(date_dict: Dictionary, days: int) -> Dictionary:
	# Convert to unix, subtract, convert back
	var unix = Time.get_unix_time_from_datetime_dict(date_dict)
	var secs = days * 24 * 60 * 60
	unix -= secs
	return Time.get_datetime_dict_from_unix_time(int(unix))
	
func add_days_to_date(date_dict: Dictionary, days: int) -> Dictionary:
	# Convert to unix, subtract, convert back
	var unix = Time.get_unix_time_from_datetime_dict(date_dict)
	var secs = days * 24 * 60 * 60
	unix += secs
	return Time.get_datetime_dict_from_unix_time(int(unix))
	
func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_error("API request failed with code %s" % response_code)
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		push_error("Failed to parse JSON")
		return
	data = json["properties"]
	data = data["parameter"]
	var date_str = convert_date_to_string(date)
	$UI/top_left/VFlowContainer/listitem/MarginContainer/Panel/Label.text ="Temp : "+ str(data["T2M"][date_str])
	$UI/top_left/VFlowContainer/listitem2/MarginContainer/Panel/Label.text ="Soil Type : "+ soil_type
	$UI/top_left/VFlowContainer/listitem3/MarginContainer/Panel/Label.text ="Wind Speed :"+ str(data["WS2M"][date_str])
	$UI/top_left/VFlowContainer/listitem3/MarginContainer/image_node/TextureRect.rotation_degrees = float(data["WD2M"][date_str])
	$UI/top_left/VFlowContainer/listitem4/MarginContainer/Panel/Label.text ="Country : "+ str(selected_country.name)
	$UI/top_left/VFlowContainer/listitem5/MarginContainer/Panel/Label.text ="Date : "+ str(date["year"])+"/"+str(date["month"])+"/"+str(date["day"])
	$UI/top_left/VFlowContainer/listitem6/MarginContainer/Panel/Label.text ="Humidity :"+ str(data["QV2M"][date_str])
	$UI/top_left/VFlowContainer/listitem7/MarginContainer/Panel/Label.text ="Soil Moisture :"+ str(data["GWETTOP"][date_str])
	number_of_weeks+=1
	#$UI/top_left/VFlowContainer/listitem3.image_rotation = float(data["WD2M"][date_str])
