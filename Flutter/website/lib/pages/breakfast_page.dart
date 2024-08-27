import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:website/components/meal_replace_options.dart';
import 'package:website/components/micro_bar_widget.dart';

class MealRecommendationPage extends StatefulWidget {
  final int dayIndex;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;
  final String dietaryPreference;
  final int numberOfMeals;

  MealRecommendationPage({
    Key? key,
    required this.dayIndex,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.dietaryPreference,
    required this.numberOfMeals,
  }) : super(key: key);

  @override
  _MealRecommendationPageState createState() => _MealRecommendationPageState();
}

class _MealRecommendationPageState extends State<MealRecommendationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<dynamic> mealIds = [];
  List<dynamic> macros = [];
  List<Map<String, dynamic>> mealDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendedMeals();
  }

  Future<void> fetchRecommendedMeals() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/recommend'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "user_id": "fghftfhghg",
        "Calories": widget.calories,
        "Protein": widget.protein,
        "Fat": widget.fats,
        "Carbs": widget.carbs,
        "meal_count": widget.numberOfMeals,
        "selected_meal_id": "n/a",
        "dietery": "n/a",
      }),
    );

    if (response.statusCode == 200) {
      var mealResponse = jsonDecode(response.body);

      setState(() {
        mealIds = mealResponse['closest_meal_ids'];
        macros = mealResponse['closest_meals'];
        mealDetails =
            List<Map<String, dynamic>>.from(mealResponse['meal_info']);
        updateMacroDisplay(); // Update macro display when meals are fetched
      });
    } else {
      throw Exception('Failed to load recommendations');
    }

    setState(() {
      isLoading = false;
    });
  }

  void updateMacroDisplay() {
    double totalCalories = 0.0;
    double totalCarbs = 0.0;
    double totalProtein = 0.0;
    double totalFat = 0.0;

    mealDetails.forEach((meal) {
      totalCalories += double.parse(meal['Calories'].toString());
      totalCarbs += double.parse(meal['Carbs'].toString());
      totalProtein += double.parse(meal['Protein'].toString());
      totalFat += double.parse(meal['Fat'].toString());
    });

    setState(() {
      macros = [totalCalories, totalCarbs, totalProtein, totalFat];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading || mealDetails.isEmpty || macros.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic> mappedMacros = mapMacrosToList(macros);

    return Scaffold(
      body: Container(
        color: Color(0xFFFFF5E1),
        child: Stack(
          children: [
            // Background image with reduced opacity
            Image.asset(
              'images/home_page.jpg', // Make sure the path to the image is correct
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
              width: double.infinity,
              height: double.infinity,
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 40, bottom: 8),
                          child: const Text(
                            'Your Personalized Daily Meal Plan',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MacroDisplayWidget(
                              calories: mappedMacros['Calories'],
                              carbs: mappedMacros['Carbs'],
                              protein: mappedMacros['Protein'],
                              fat: mappedMacros['Fat'],
                              targetCalories: widget.calories,
                              targetCarbs: widget.carbs,
                              targetProtein: widget.protein,
                              targetFat: widget.fats,
                              onPressed: fetchRecommendedMeals,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mealDetails.map((meal) {
                        return MealDetailCard(
                          textColor: Colors.white,
                          title: meal['Menu Item'],
                          imagePath: meal['Images'],
                          nutritionInfo: {
                            "Calories": "${meal['Calories']} Kcal",
                            "Protein": "${meal['Protein']} g",
                            "Carbs": "${meal['Carbs']} g",
                            "Fat": "${meal['Fat']} g",
                          },
                          servingSize: "Serving size information",
                          buttonText: "Replace",
                          onPressedBandS: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MealReplaceOptions(
                                  breakfastSnack: true,
                                  currentMealId: meal['id'],
                                  jsonFilePath: 'assets/sorted_distances.json',
                                  onMealSelected: (selectedMealId) async {
                                    // Fetch the details of the selected meal
                                    String data = await rootBundle.loadString(
                                        'assets/rfg_data_zero.json');
                                    List<dynamic> meals = jsonDecode(data);
                                    var selectedMeal = meals.firstWhere(
                                        (meal) => meal['id'] == selectedMealId,
                                        orElse: () => {});

                                    // Update the mealDetails with the selected meal
                                    setState(() {
                                      mealDetails = mealDetails.map((m) {
                                        if (m['id'] == meal['id']) {
                                          return selectedMeal
                                              as Map<String, dynamic>;
                                        }
                                        return m;
                                      }).toList();

                                      // Update the macros based on the new meal selection
                                      updateMacroDisplay();
                                    });
                                  },
                                );
                              },
                            );
                          },
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MealReplaceOptions(
                                  breakfastSnack: false,
                                  currentMealId: meal['id'],
                                  jsonFilePath: 'assets/sorted_distances.json',
                                  onMealSelected: (selectedMealId) async {
                                    // Fetch the details of the selected meal
                                    String data = await rootBundle.loadString(
                                        'assets/rfg_data_zero.json');
                                    List<dynamic> meals = jsonDecode(data);
                                    var selectedMeal = meals.firstWhere(
                                        (meal) => meal['id'] == selectedMealId,
                                        orElse: () => {});

                                    // Update the mealDetails with the selected meal
                                    setState(() {
                                      mealDetails = mealDetails.map((m) {
                                        if (m['id'] == meal['id']) {
                                          return selectedMeal
                                              as Map<String, dynamic>;
                                        }
                                        return m;
                                      }).toList();

                                      // Update the macros based on the new meal selection
                                      updateMacroDisplay();
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> mapMacrosToList(List<dynamic> macroValues) {
    List<String> macroNames = ['Calories', 'Carbs', 'Protein', 'Fat'];
    Map<String, dynamic> macrosMap = {};

    for (int i = 0; i < macroNames.length; i++) {
      macrosMap[macroNames[i]] = macroValues[i];
    }

    return macrosMap;
  }
}
