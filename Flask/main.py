import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from GeneticAlgorithm.genetic_algorithm import MealRecommender
from flask import Flask, request, jsonify
import sys
import os
import logging
from flask_cors import CORS
from flask_cors import CORS, cross_origin
import json

app = Flask(__name__)
CORS(app, resources={r"/recommend": {"origins": "*"}})

logging.basicConfig(level=logging.INFO)


@app.route('/recommend', methods=['POST'])
@cross_origin() 
def recommend():
    try:
        # Extract user_id from the request data
        data = request.json
        user_id = data.get('user_id')

        calories = data.get('Calories')
        carbs = data.get('Carbs')
        protein = data.get('Protein')
        fat = data.get('Fat')
        dietery = data.get('dietery')

        meal_count = data.get('meal_count')

        target = {
            'Calories': calories, 
            'Protein': protein, 
            'Fat': fat, 
            'Carbs': carbs
            }
        
        # dietery = data.get('dietery')

        # Validate that a user_id is provided
        if not user_id:
            raise ValueError("No user_id provided in request.")

        # if selected_meal_id == 'n/a':
        # Instantiate and use the HealthyFoodRecommender
        csv_file_path = os.path.join(os.path.dirname(__file__), '../GeneticAlgorithm/rfg data.csv')

        recommender = MealRecommender(csv_file_path, target, meal_count=meal_count, population_size=20, generation_limit=500, mutation_rate=0.4, k=1, dietery=dietery)
        closest_meals, closest_meal_ids, closest_distances, meal_info = recommender.meal_recommendation(target)


        closest_meals_list = [meal.tolist() for meal in closest_meals]

        # Create a dictionary to hold the data
        data = {
            "closest_meals": closest_meals_list[0],
            "closest_meal_ids": closest_meal_ids[0],
            "closest_distances": closest_distances[0],
            "meal_info": meal_info
        }

        # Serialize to JSON
        json_data = json.dumps(data, indent=4)

        return json_data

    except ValueError as ve:
        # Handle specific value errors, e.g., missing user_id
        logging.error(f"Value Error: {ve}")
        return jsonify(error=str(ve)), 400

    except Exception as e:
        # Handle any unexpected errors
        logging.error(f"Unexpected error: {e}")
        return jsonify(error="Internal Server Error"), 500

if __name__ == '__main__':
    app.run(debug=True)



