import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'dart:convert';

class MealReplaceOptions extends StatefulWidget {
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

  @override
  _MealReplaceOptionsState createState() => _MealReplaceOptionsState();
}

class _MealReplaceOptionsState extends State<MealReplaceOptions> {
  late Future<List<int>> _closestMealsFuture;
  List<int> _filteredMealIds = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _closestMealsFuture = loadClosestMeals();
  }

  Future<List<int>> loadClosestMeals() async {
    String data = await rootBundle.loadString(widget.jsonFilePath);
    Map<String, dynamic> jsonData = jsonDecode(data);
    List<int> mealIds =
        List<int>.from(jsonData[widget.currentMealId.toString()] ?? []);

    // Load full meal data for filtering
    String mealsData = await rootBundle.loadString('assets/rfg_updated.json');
    List<dynamic> meals = jsonDecode(mealsData);

    if (widget.breakfastSnack) {
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

    setState(() {
      _filteredMealIds = mealIds;
    });

    return mealIds;
  }

  Future<Map<String, dynamic>> fetchMealDetails(int mealId) async {
    String data = await rootBundle.loadString('assets/rfg_updated.json');
    List<dynamic> meals = jsonDecode(data);
    return meals.firstWhere((meal) => meal['id'] == mealId, orElse: () => {});
  }

  void _filterMeals(String query) async {
    _searchQuery = query;
    List<int> allMealIds = await _closestMealsFuture;
    if (query.isEmpty) {
      setState(() {
        _filteredMealIds = allMealIds;
      });
      return;
    }

    String mealsData = await rootBundle.loadString('assets/rfg_updated.json');
    List<dynamic> meals = jsonDecode(mealsData);

    final regex = RegExp(query, caseSensitive: false);
    final filtered = allMealIds.where((mealId) {
      final meal = meals.firstWhere((meal) => meal['id'] == mealId,
          orElse: () => null);
      if (meal == null) return false;
      return regex.hasMatch(meal['Menu Item'] ?? "");
    }).toList();

    setState(() {
      _filteredMealIds = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: _closestMealsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading meal options'));
        } else {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Meals',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterMeals,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width <
                                    700
                                ? 1 // Mobile
                                : MediaQuery.of(context).size.width < 1300
                                    ? 2 // Tablet
                                    : 3, // Desktop
                            childAspectRatio:
                                MediaQuery.of(context).size.width < 700
                                    ? 0.5 // Mobile - wider ratio
                                    : MediaQuery.of(context).size.width < 900
                                        ? 0.67
                                        : MediaQuery.of(context).size.width <
                                                1300
                                            ? 0.9
                                            : MediaQuery.of(context).size.width <
                                                    1400
                                                ? 0.8
                                                : 0.9, // Desktop - wider ratio
                            crossAxisSpacing:
                                MediaQuery.of(context).size.width * 0.02,
                            mainAxisSpacing:
                                MediaQuery.of(context).size.height * 0.02,
                          ),
                          itemCount: _filteredMealIds.length,
                          itemBuilder: (context, index) {
                            final mealId = _filteredMealIds[index];
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
                                      widget.onMealSelected(mealId);
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
