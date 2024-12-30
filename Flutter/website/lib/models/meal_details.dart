class MealDetails {
  final String mealType;
  final String title;
  final String? description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int day;

  MealDetails({
    required this.mealType,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.day,
  });
}