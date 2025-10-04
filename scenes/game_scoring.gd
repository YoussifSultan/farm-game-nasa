# CropScoring.gd
extends Node

# Complex agricultural scoring simulation with player tips
func calculate_crop_scores(
	soil_moisture: float, 
	humidity: float, 
	temperature: float, 
	water_mm: float,
	soil_N: float, 
	soil_type: String, 
	fertilizer_kg_per_ha: float, 
	crop_stage: String,
	pest_control: String, 
	harvest_timing: String
) -> Dictionary:

	# --- Base scores ---
	var crop_quality = 50
	var crop_quantity = 50
	var environment_score = 50
	var tips = []

	# --- Weather modifiers (baseline) ---
	var weather_modifier_quality = 0
	var weather_modifier_quantity = 0

	# Soil moisture effect
	if soil_moisture < 30:
		weather_modifier_quality -= 10
		weather_modifier_quantity -= 15
		tips.append("Soil is too dry! Consider irrigating or planting drought-resistant crops.")
	elif soil_moisture >= 30 and soil_moisture <= 50:
		weather_modifier_quality += 5
		weather_modifier_quantity += 5
	elif soil_moisture > 80:
		weather_modifier_quality -= 5
		weather_modifier_quantity += 2
		tips.append("Soil is too wet! Avoid overwatering to prevent root issues.")

	# Humidity effect
	if humidity < 40:
		weather_modifier_quality -= 5
		weather_modifier_quantity -= 5
		tips.append("Low humidity detected. Monitor water and crop health.")
	elif humidity >= 60 and humidity <= 80:
		weather_modifier_quality += 5
		weather_modifier_quantity += 5

	# Temperature effect
	if temperature < 15:
		weather_modifier_quality -= 10
		weather_modifier_quantity -= 10
		tips.append("Temperature is too low! Protect crops from cold stress.")
	elif temperature >= 25 and temperature <= 30:
		weather_modifier_quality += 5
		weather_modifier_quantity += 5
	elif temperature > 35:
		weather_modifier_quality -= 15
		weather_modifier_quantity -= 20
		tips.append("High temperature! Consider shading or heat-tolerant varieties.")

	# Apply weather modifiers
	crop_quality += weather_modifier_quality
	crop_quantity += weather_modifier_quantity

	# --- Fertilizer effectiveness ---
	var fertilizer_effect = 0
	if fertilizer_kg_per_ha < 50:
		fertilizer_effect -= 10
		tips.append("Low fertilizer applied. Crop growth may be limited.")
	elif fertilizer_kg_per_ha >= 50 and fertilizer_kg_per_ha <= 150:
		fertilizer_effect += 10
	elif fertilizer_kg_per_ha > 150 and fertilizer_kg_per_ha <= 250:
		fertilizer_effect += 5  # diminishing returns
	elif fertilizer_kg_per_ha > 250:
		fertilizer_effect -= 5
		tips.append("Too much fertilizer! Over-fertilization can harm crop quality and environment.")

	# Soil type interaction
	if soil_type == "Sandy":
		fertilizer_effect *= 0.8
	elif soil_type == "Clay":
		fertilizer_effect *= 1.0
	elif soil_type == "Loamy":
		fertilizer_effect *= 1.2

	# Moisture interaction
	if soil_moisture < 40:
		fertilizer_effect *= 0.5
		tips.append("Fertilizer less effective in dry soil. Consider watering before applying.")

	crop_quality += fertilizer_effect
	crop_quantity += fertilizer_effect * 1.2

	# --- Nitrogen level effect ---
	if soil_N < 30:
		crop_quality -= 10
		crop_quantity -= 15
		tips.append("Nitrogen deficiency detected! Consider fertilization or soil improvement.")
	elif soil_N >= 50 and soil_N <= 100:
		crop_quality += 10
		crop_quantity += 10
	elif soil_N > 200:
		crop_quality -= 5
		crop_quantity += 5
		environment_score -= 10
		tips.append("Excessive nitrogen! Can harm environment and water quality.")

	# --- Pest control effect ---
	if pest_control == "Chemical":
		crop_quality -= 10
		crop_quantity += 10
		environment_score -= 20
		tips.append("Chemical pest control used. Eco-friendly alternatives may improve environment score.")
	elif pest_control == "Eco":
		crop_quality += 5
		crop_quantity += 5
		environment_score += 15

	# --- Harvest timing effect ---
	if harvest_timing == "Early":
		crop_quality += 10
		crop_quantity -= 15
		environment_score += 5
		tips.append("Early harvest can improve quality but reduce quantity.")
	elif harvest_timing == "Late":
		crop_quality -= 15
		crop_quantity += 10
		environment_score -= 5
		tips.append("Late harvest increases quantity but may lower quality.")

	# --- Crop stage interactions ---
	if crop_stage == "Early" and fertilizer_kg_per_ha > 100:
		crop_quality -= 5
		tips.append("Too much fertilizer in early stage may reduce quality.")
	if crop_stage == "Late" and water_mm < 30:
		crop_quantity -= 10
		tips.append("Late-stage drought reduces yield. Consider irrigation.")

	# --- Random fluctuations ---
	var random_factor_quality = randi() % 5 - 2
	var random_factor_quantity = randi() % 5 - 2
	var random_factor_environment = randi() % 3 - 1

	crop_quality += random_factor_quality
	crop_quantity += random_factor_quantity
	environment_score += random_factor_environment

	# --- Clamp scores ---
	crop_quality = clamp(crop_quality, 0, 100)
	crop_quantity = clamp(crop_quantity, 0, 100)
	environment_score = clamp(environment_score, 0, 100)

	return {
		"crop_quality": crop_quality,
		"crop_quantity": crop_quantity,
		"environment_score": environment_score,
		"tips": tips
	}

# ------------------------------
# Function to determine soil nitrogen based on soil type
func get_soil_N(soil_type: String, range_type: String = "optimal") -> int:
	"""
	soil_type: "Sandy", "Loamy", or "Clay"
	range_type: "low", "optimal", "high"
	Returns: soil nitrogen in kg/ha
	"""
	var low_N = 0
	var optimal_N = 0
	var high_N = 0

	match soil_type:
		"Sandy":
			low_N = 10
			optimal_N = 50
			high_N = 100
		"Loamy":
			low_N = 20
			optimal_N = 85
			high_N = 150
		"Clay":
			low_N = 30
			optimal_N = 125
			high_N = 250
		_:
			# Default values if soil type unknown
			low_N = 20
			optimal_N = 80
			high_N = 150

	match range_type:
		"low":
			return low_N
		"optimal":
			return optimal_N
		"high":
			return high_N
		_:
			return optimal_N  # fallback
			
			
