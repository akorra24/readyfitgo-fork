import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'dart:convert';

class MealReplaceOptions extends StatelessWidget {
  final int currentMealId;
  final String jsonFilePath;
  final Function(int) onMealSelected;

  const MealReplaceOptions({
    Key? key,
    required this.currentMealId,
    required this.jsonFilePath,
    required this.onMealSelected,
  }) : super(key: key);

  Future<List<int>> loadClosestMeals() async {
    String data = await rootBundle.loadString(jsonFilePath);
    Map<String, dynamic> jsonData = jsonDecode(data);
    return List<int>.from(jsonData[currentMealId.toString()] ?? []);
  }

  Future<Map<String, dynamic>> fetchMealDetails(int mealId) async {
    String data = await rootBundle.loadString('assets/rfg_data_zero.json');
    List<dynamic> meals = jsonDecode(data);
    return meals.firstWhere((meal) => meal['id'] == mealId, orElse: () => {})
        as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: loadClosestMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading meal options'));
        } else {
          final closestMealIds = snapshot.data!;
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of meal cards per row
                  childAspectRatio: 0.64, // Adjust this to control card height
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: closestMealIds.length,
                itemBuilder: (context, index) {
                  final mealId = closestMealIds[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchMealDetails(mealId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading meal details');
                      } else {
                        final meal = snapshot.data!;
                        return MealDetailCard(
                          title: meal['Menu Item'],
                          imagePath: meal['Images'],
                          nutritionInfo: {
                            "Calories": "${meal['Calories']} Kcal",
                            "Protein": "${meal['Protein']} g",
                            "Carbs": "${meal['Carbs']} g",
                            "Fat": "${meal['Fat']} g",
                          },
                          servingSize: "Serving size information",
                          buttonText: "Select",
                          onPressed: () {
                            onMealSelected(mealId);
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
