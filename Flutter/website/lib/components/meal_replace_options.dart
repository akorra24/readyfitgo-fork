import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'dart:convert';

class MealReplaceOptions extends StatelessWidget {
  final int currentMealId;
  final String jsonFilePath;
  final bool breakfastSnack;
  final Function(int) onMealSelected;

  const MealReplaceOptions({
    Key? key,
    required this.currentMealId,
    required this.breakfastSnack,
    required this.jsonFilePath,
    required this.onMealSelected,
  }) : super(key: key);

  Future<List<int>> loadClosestMeals() async {
    String data = await rootBundle.loadString(jsonFilePath);
    Map<String, dynamic> jsonData = jsonDecode(data);
    List<int> mealIds =
        List<int>.from(jsonData[currentMealId.toString()] ?? []);

    // Load full meal data for filtering
    String mealsData = await rootBundle.loadString('assets/rfg_updated.json');
    List<dynamic> meals = jsonDecode(mealsData);

    if (breakfastSnack) {
      // Filter meal IDs based on whether the meal is a breakfast or snack
      mealIds = mealIds.where((mealId) {
        final meal = meals.firstWhere((meal) => meal['id'] == mealId,
            orElse: () => null);
        if (meal == null) return false;
        final mealType = meal['Meal Type']?.trim().toLowerCase();
        return mealType == 'breakfast' ||
            mealType == 'snack' ||
            mealType == 'breakfast and snack';
      }).toList();
    }

    return mealIds;
  }

  Future<Map<String, dynamic>> fetchMealDetails(int mealId) async {
    String data = await rootBundle.loadString('assets/rfg_updated.json');
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
              child: Stack(children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 700
                        ? 1 // Mobile
                        : MediaQuery.of(context).size.width < 1300
                            ? 2 // Tablet
                            : 3, // Desktop
                    childAspectRatio: MediaQuery.of(context).size.width < 700
                        ? 0.5 // Mobile - wider ratio
                        : MediaQuery.of(context).size.width < 900
                            ? 0.67
                            : MediaQuery.of(context).size.width < 1300
                                ? 0.9
                                : MediaQuery.of(context).size.width < 1400
                                    ? 0.8
                                    : 0.9, // Desktop - wider ratio
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                    mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                  ),
                  itemCount: closestMealIds.length,
                  itemBuilder: (context, index) {
                    final mealId = closestMealIds[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchMealDetails(mealId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading meal details');
                        } else {
                          final meal = snapshot.data!;
                          print('Meal ID: $mealId');

                          return MealDetailCard(
                            title: meal['Menu Item'],
                            imagePath: meal['Images'],
                            textColor: Colors.black,
                            replaceCard: true,
                            nutritionInfo: {
                              "Calories": "${meal['Calories']} Kcal",
                              "Protein": "${meal['Protein']} g",
                              "Carbs": "${meal['Carbs']} g",
                              "Fat": "${meal['Fat']} g",
                            },
                            ingredients: meal["Ingredients"],
                            servingSize: "Serving size information",
                            buttonText: "Select",
                            onPressed: () {
                              // print('Meal ID: $mealId');
                              onMealSelected(mealId);
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ]),
            ),
          );
        }
      },
    );
  }
}
