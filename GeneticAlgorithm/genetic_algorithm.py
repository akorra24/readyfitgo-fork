
from random import choices, randint, randrange, random, sample, choice
from typing import List, Callable, Tuple
import numpy as np
import time
import os
import pandas as pd
import json

Genome = List[int]
Population = List[Genome]
FitnessFunc = Callable[[Genome], float]
SelectionFunc = Callable[[Population, FitnessFunc], Tuple[Genome, Genome]]
CrossoverFunc = Callable[[Genome, Genome], Tuple[Genome, Genome]]
MutationFunc = Callable[[Genome], Genome]

class MealRecommender:
    def __init__(self, filepath: str, target: dict, meal_count: int, population_size: int, generation_limit: int, mutation_rate: float, k: int, dietery='n/a'):
        
        # csv_file_path = filepath

        # Read the CSV file into a DataFrame
        # df = pd.read_csv(csv_file_path)

        # # Specify the columns that contain the nutrient information
        # nutrient_columns = ["Calories", "Protein", "Fat", "Carbs"]

        # if dietery == 'veg':
        #   df = df[df['Vegan or/and  Vegetarian'] == 'Vegetarian']

        # elif dietery == 'vegan':
        #   df = df[df['Vegan or/and  Vegetarian'] == 'Vegan and Vegetarian']

        # # Ensure the nutrient columns are of type float
        # df[nutrient_columns] = df[nutrient_columns].astype(float)

        # # Extract only the nutrient columns
        # nutrient_df = df[nutrient_columns]

        # Convert the DataFrame to a list of dictionaries

        json_file_path = os.path.join(os.path.dirname(__file__), '../GeneticAlgorithm/rfg_data_zero.json')

        # Read the JSON file and convert to a dictionary
        with open(json_file_path, 'r') as file:
            MEAL_LIST = json.load(file)

        def filter_meals_by_dietery(meal_list, dietery):
            """Filter meals based on the dietery variable: 'veg' or 'vegan'."""
            filtered_meals = []

            for meal in meal_list:
                if dietery == 'Vegetarian' and meal.get("Vegan or/and  Vegetarian") == "Vegetarian":
                    filtered_meals.append(meal)
                elif dietery == 'Vegan' and meal.get("Vegan or/and  Vegetarian") == "Vegan and Vegetarian":
                    filtered_meals.append(meal)

            return filtered_meals
        
        if dietery != "None":
            # Example usage
            MEAL_LIST = filter_meals_by_dietery(MEAL_LIST, dietery)
        
        self.meals = MEAL_LIST
        self.target = target
        self.meal_count = meal_count
        self.population_size = population_size
        self.generation_limit = generation_limit
        self.mutation_rate = mutation_rate
        self.k = k
        self.matrix_file = 'meal_distance_matrix.npy'

    def generate_genome(self) -> Genome:
        return sample(range(len(self.meals)), self.meal_count)  # Changed to 'sample' for uniqueness

    def fitness(self, genome: Genome) -> float:
        sum_nutrients = {'Calories': 0, 'Protein': 0, 'Fat': 0, 'Carbs': 0}
        for index in genome:
            for nutrient in sum_nutrients:
                sum_nutrients[nutrient] += self.meals[index][nutrient]
        fitness = sum(abs(sum_nutrients[nutrient] - self.target[nutrient]) for nutrient in self.target)
        return 1 / (1 + fitness)

    def single_point_crossover_unique(self, a: Genome, b: Genome) -> Tuple[Genome, Genome]:
        if len(a) != len(b):
            raise ValueError("Genomes a and b must be of the same length")
        length = len(a)
        if length < 2:
            return a[:], b[:]
        p = randint(1, length - 1)
        child_a = a[:p] + [gene for gene in b if gene not in a[:p]]
        child_b = b[:p] + [gene for gene in a if gene not in b[:p]]
        # Ensure children are of correct length
        child_a = child_a[:length]
        child_b = child_b[:length]
        return child_a, child_b

    def mutation_unique(self, genome: Genome) -> Genome:
        genome_set = set(genome)
        for i in range(len(genome)):
            if random() < self.mutation_rate:
                available_genes = set(range(len(self.meals))) - genome_set
                if available_genes:
                    new_gene = choice(list(available_genes))  # Use 'choice' from random, not random.choice
                    genome_set.remove(genome[i])
                    genome_set.add(new_gene)
                    genome[i] = new_gene
        return genome

    def generate_population(self) -> Population:
        return [self.generate_genome() for _ in range(self.population_size)]

    def run_evolution(self, populate_func: Callable[[], Population], fitness_func: FitnessFunc,
                      selection_func: SelectionFunc, crossover_func: CrossoverFunc,
                      mutation_func: MutationFunc) -> Tuple[Population, int]:
        population = populate_func()
        for generation in range(self.generation_limit):
            population = sorted(population, key=fitness_func, reverse=True)
            if fitness_func(population[0]) == 1:
                break
            next_generation = population[:2]
            while len(next_generation) < self.population_size:
                parents = selection_func(population, fitness_func)
                offspring_a, offspring_b = crossover_func(parents[0], parents[1])
                offspring_a = mutation_func(offspring_a)
                offspring_b = mutation_func(offspring_b)
                next_generation += [offspring_a, offspring_b]
            population = next_generation
        return population, generation

    def meal_recommendation(self, adjusted_target: dict) -> Tuple[List[dict], List[Tuple[int, int, int]], List[float]]:
        self.target = adjusted_target
        s_time = time.time()

        population_func = self.generate_population
        best_population, generations = self.run_evolution(
            populate_func=population_func,
            fitness_func=self.fitness,
            selection_func=lambda pop, fit: choices(
                population=pop,
                weights=[fit(g) for g in pop],
                k=2),
            crossover_func=self.single_point_crossover_unique,  # Updated crossover function
            mutation_func=self.mutation_unique  # Updated mutation function
        )

        combined = []
        best_meals = {}
        for genome in best_population:
            meal_combination = [self.meals[i] for i in genome]
            combined_nutrients = {nutrient: sum(meal[nutrient] for meal in meal_combination) for nutrient in self.target}

            meal_ids = tuple(genome)
            if combined_nutrients not in combined:
                combined.append(combined_nutrients)
                best_meals[meal_ids] = combined_nutrients

        combined_meals = list(best_meals.values())

        target_array = np.array(list(self.target.values()))
        weights = np.array([1, 1, 1, 1])

        meal_array = np.array([[meal['Calories'], meal['Protein'], meal['Fat'], meal['Carbs']] for meal in combined_meals])

        def calculate_weighted_distance(meal):
            differences = np.linalg.norm(meal - target_array)
            weighted_differences = differences * weights
            return np.linalg.norm(weighted_differences)

        sorted_meals = sorted(meal_array, key=calculate_weighted_distance)
        closest_meals = sorted_meals[:self.k]
        closest_meal_ids = [list(best_meals.keys())[list(best_meals.values()).index(dict(zip(['Calories', 'Protein', 'Fat', 'Carbs'], meal)))] for meal in closest_meals]
        closest_distances = [calculate_weighted_distance(meal) for meal in closest_meals]
        # print(list(closest_meal_ids[0]))
        # print(self.meals[list(closest_meal_ids[0])[0]])
        meal_info = [self.meals[id] for id in list(closest_meal_ids[0])]
        print(meal_info)

        return closest_meals, closest_meal_ids, closest_distances, meal_info

    def get_closest_meals(self, meal_id: int, k: int) -> List[int]:
        if not os.path.exists(self.matrix_file):
            meal_array = np.array([[meal['Calories'], meal['Protein'], meal['Fat'], meal['Carbs']] for meal in self.meals])
            distance_matrix = np.zeros((len(meal_array), len(meal_array)))
            for i in range(len(meal_array)):
                for j in range(len(meal_array)):
                    distance_matrix[i, j] = np.linalg.norm(meal_array[i] - meal_array[j])
            sorted_indices = np.argsort(distance_matrix, axis=1)
            np.save(self.matrix_file, sorted_indices)
        else:
            sorted_indices = np.load(self.matrix_file)

        return sorted_indices[meal_id, 1:k+1].tolist()

    def adjust_target(self, selected_meal_id: int) -> dict:
        selected_meal = self.meals[selected_meal_id]
        adjusted_target = {nutrient: self.target[nutrient] - selected_meal[nutrient] for nutrient in self.target}
        # self.target = adjusted_target
        return adjusted_target


# Example of how to initialize and use the recommender:
# target = {'Calories': 1400.0, 'Protein': 130.0, 'Fat': 40.0, 'Carbs': 120.0}

# recommender = MealRecommender("/content/rfg data.csv", target, meal_count=2, population_size=20, generation_limit=500, mutation_rate=0.4, k=1)


# from random import choices, randint, randrange, random
# from typing import List, Callable, Tuple
# import numpy as np
# import time
# import os
# import pandas as pd
# import json

# Genome = List[int]
# Population = List[Genome]
# FitnessFunc = Callable[[Genome], float]
# SelectionFunc = Callable[[Population, FitnessFunc], Tuple[Genome, Genome]]
# CrossoverFunc = Callable[[Genome, Genome], Tuple[Genome, Genome]]
# MutationFunc = Callable[[Genome], Genome]

# class MealRecommender:
#     def __init__(self, filepath: str, target: dict, meal_count: int, population_size: int, generation_limit: int, mutation_rate: float, k: int, dietery='n/a'):
        
#         csv_file_path = filepath

#         # Read the CSV file into a DataFrame
#         df = pd.read_csv(csv_file_path)

#         # Specify the columns that contain the nutrient information
#         nutrient_columns = ["Calories", "Protein", "Fat", "Carbs"]

#         if dietery == 'veg':
#           df = df[df['Vegan or/and  Vegetarian'] == 'Vegetarian']

#         elif dietery == 'vegan':
#           df = df[df['Vegan or/and  Vegetarian'] == 'Vegan and Vegetarian']

#         # Ensure the nutrient columns are of type float
#         df[nutrient_columns] = df[nutrient_columns].astype(float)

#         # Extract only the nutrient columns
#         nutrient_df = df[nutrient_columns]

#         # Convert the DataFrame to a list of dictionaries

#         json_file_path = os.path.join(os.path.dirname(__file__), '../GeneticAlgorithm/rfg_data_zero.json')

#         # Read the JSON file and convert to a dictionary
#         with open(json_file_path, 'r') as file:
#             MEAL_LIST = json.load(file)
        
#         self.meals = MEAL_LIST
#         self.target = target
#         self.meal_count = meal_count
#         self.population_size = population_size
#         self.generation_limit = generation_limit
#         self.mutation_rate = mutation_rate
#         self.k = k
#         self.matrix_file = 'meal_distance_matrix.npy'

#     def generate_genome(self) -> Genome:
#         return choices(range(len(self.meals)), k=self.meal_count)

#     def fitness(self, genome: Genome) -> float:
#         sum_nutrients = {'Calories': 0, 'Protein': 0, 'Fat': 0, 'Carbs': 0}
#         for index in genome:
#             for nutrient in sum_nutrients:
#                 sum_nutrients[nutrient] += self.meals[index][nutrient]
#         fitness = sum(abs(sum_nutrients[nutrient] - self.target[nutrient]) for nutrient in self.target)
#         return 1 / (1 + fitness)

#     def single_point_crossover(self, a: Genome, b: Genome) -> Tuple[Genome, Genome]:
#         if len(a) != len(b):
#             raise ValueError("Genomes a and b must be of the same length")
#         length = len(a)
#         if length < 2:
#             return a, b
#         p = randint(1, length - 1)
#         return a[:p] + b[p:], b[:p] + a[p:]

#     def mutation(self, genome: Genome) -> Genome:
#         return [gene if random() > self.mutation_rate else randrange(len(self.meals)) for gene in genome]

#     def generate_population(self) -> Population:
#         return [self.generate_genome() for _ in range(self.population_size)]

#     def run_evolution(self, populate_func: Callable[[], Population], fitness_func: FitnessFunc,
#                       selection_func: SelectionFunc, crossover_func: CrossoverFunc,
#                       mutation_func: MutationFunc) -> Tuple[Population, int]:
#         population = populate_func()
#         for generation in range(self.generation_limit):
#             population = sorted(population, key=fitness_func, reverse=True)
#             if fitness_func(population[0]) == 1:
#                 break
#             next_generation = population[:2]
#             while len(next_generation) < self.population_size:
#                 parents = selection_func(population, fitness_func)
#                 offspring_a, offspring_b = crossover_func(parents[0], parents[1])
#                 offspring_a = mutation_func(offspring_a)
#                 offspring_b = mutation_func(offspring_b)
#                 next_generation += [offspring_a, offspring_b]
#             population = next_generation
#         return population, generation

#     def meal_recommendation(self, adjusted_target: dict) -> Tuple[List[dict], List[Tuple[int, int, int]], List[float]]:
#         self.target = adjusted_target
#         s_time = time.time()

#         population_func = self.generate_population
#         best_population, generations = self.run_evolution(
#             populate_func=population_func,
#             fitness_func=self.fitness,
#             selection_func=lambda pop, fit: choices(
#                 population=pop,
#                 weights=[fit(g) for g in pop],
#                 k=2),
#             crossover_func=self.single_point_crossover,
#             mutation_func=self.mutation
#         )

#         combined = []
#         best_meals = {}
#         for genome in best_population:
#             meal_combination = [self.meals[i] for i in genome]
#             combined_nutrients = {nutrient: sum(meal[nutrient] for meal in meal_combination) for nutrient in self.target}

#             meal_ids = tuple(genome)
#             if combined_nutrients not in combined:
#                 combined.append(combined_nutrients)
#                 best_meals[meal_ids] = combined_nutrients

#         combined_meals = list(best_meals.values())

#         target_array = np.array(list(self.target.values()))
#         weights = np.array([1, 1, 1, 1])

#         meal_array = np.array([[meal['Calories'], meal['Protein'], meal['Fat'], meal['Carbs']] for meal in combined_meals])

#         def calculate_weighted_distance(meal):
#             differences = np.linalg.norm(meal - target_array)
#             weighted_differences = differences * weights
#             return np.linalg.norm(weighted_differences)

#         sorted_meals = sorted(meal_array, key=calculate_weighted_distance)
#         closest_meals = sorted_meals[:self.k]
#         closest_meal_ids = [list(best_meals.keys())[list(best_meals.values()).index(dict(zip(['Calories', 'Protein', 'Fat', 'Carbs'], meal)))] for meal in closest_meals]
#         closest_distances = [calculate_weighted_distance(meal) for meal in closest_meals]
#         # print(list(closest_meal_ids[0]))
#         # print(self.meals[list(closest_meal_ids[0])[0]])
#         meal_info = [self.meals[id] for id in list(closest_meal_ids[0])]
#         print(meal_info)

#         return closest_meals, closest_meal_ids, closest_distances, meal_info

#     def get_closest_meals(self, meal_id: int, k: int) -> List[int]:
#         if not os.path.exists(self.matrix_file):
#             meal_array = np.array([[meal['Calories'], meal['Protein'], meal['Fat'], meal['Carbs']] for meal in self.meals])
#             distance_matrix = np.zeros((len(meal_array), len(meal_array)))
#             for i in range(len(meal_array)):
#                 for j in range(len(meal_array)):
#                     distance_matrix[i, j] = np.linalg.norm(meal_array[i] - meal_array[j])
#             sorted_indices = np.argsort(distance_matrix, axis=1)
#             np.save(self.matrix_file, sorted_indices)
#         else:
#             sorted_indices = np.load(self.matrix_file)

#         return sorted_indices[meal_id, 1:k+1].tolist()

#     def adjust_target(self, selected_meal_id: int) -> dict:
#         selected_meal = self.meals[selected_meal_id]
#         adjusted_target = {nutrient: self.target[nutrient] - selected_meal[nutrient] for nutrient in self.target}
#         # self.target = adjusted_target
#         return adjusted_target


# # target = {'Calories': 1400.0, 'Protein': 130.0, 'Fat': 40.0, 'Carbs': 120.0}

# # recommender = MealRecommender("/content/rfg data.csv", target, meal_count=2, population_size=20, generation_limit=500, mutation_rate=0.4, k=1)
