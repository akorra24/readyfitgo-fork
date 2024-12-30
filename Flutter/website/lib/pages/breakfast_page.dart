import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

import 'package:website/components/meal_replace_options.dart';
import 'package:website/components/micro_bar_widget.dart';

class MealRecommendationPage extends StatefulWidget {
  final bool isLastDay;
  final int dayIndex;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;
  final String dietaryPreference;
  final int numberOfMeals;

  MealRecommendationPage({
    Key? key,
    required this.isLastDay,
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
  final TextEditingController _emailController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
        "dietery": widget.dietaryPreference,
      }),
    );

    if (response.statusCode == 200) {
      var mealResponse = jsonDecode(response.body);
      print(mealResponse);

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

  // Send Email function
  Future<void> sendEmail(String email) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbw0S4624QX2mfFH6rgNBgyWaVWnEowUN2_yOXFETipShvpjaK_NwroM_8CNiYzsbFsg/exec'),
      headers: <String, String>{
        "Content-Type": "text/plain;charset=utf-8",
      },
      body: jsonEncode({
        "Calories": widget.calories,
        "Protein": widget.protein,
        "Fat": widget.fats,
        "Carbs": widget.carbs,
        "meal_count": widget.numberOfMeals,
        "selected_meal_id": "n/a",
        "dietery": widget.dietaryPreference,
        "email": email,
        "meal_info": mealDetails,
        "dayIndex": widget.dayIndex + 1,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email');
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xC90C1E26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Your Daily Meal Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: MediaQuery.of(context).size.width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x940C1E26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x940C1E26),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Email Button
                                      OutlinedButton.icon(
                                        onPressed: widget.isLastDay
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF0B1D26),
                                                      title: const Text(
                                                        'Enter Email',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      content: TextField(
                                                        controller:
                                                            _emailController,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter your email',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (_emailController
                                                                .text
                                                                .isNotEmpty) {
                                                              Navigator.pop(
                                                                  context);
                                                              sendEmail(
                                                                      _emailController
                                                                          .text)
                                                                  .then((_) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Email sent successfully!'),
                                                                  ),
                                                                );

                                                                _emailController
                                                                    .clear();
                                                              }).catchError(
                                                                      (error) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Failed to send email: $error'),
                                                                  ),
                                                                );
                                                              });
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Send',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                        icon: Icon(Icons.email_outlined,
                                            color: Colors.white),
                                        label: Text(
                                          'Email',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Colors.transparent),
                                          backgroundColor: widget.isLastDay
                                              ? Colors.black
                                              : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Adjust radius value as needed
                                          ),
                                        ),
                                      ),
                                      // Shop now Button
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          html.window.open(
                                              'https://readyfitgo.com/shop',
                                              '_blank');
                                        },
                                        icon: Icon(Icons.shopping_cart_outlined,
                                            color: Colors.white),
                                        label: Text(
                                          'Shop Now',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Colors.transparent),
                                          backgroundColor: Colors.black,
                                        ),
                                      ),
                                      // Regenerate Button
                                      OutlinedButton.icon(
                                        onPressed: fetchRecommendedMeals,
                                        icon: Icon(Icons.refresh,
                                            color: Colors.white),
                                        label: Text(
                                          'Regenerate',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Colors.transparent),
                                          backgroundColor: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (MediaQuery.of(context).size.width <
                                        700) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: mealDetails.map((meal) {
                                          // print("Ingredients: ${meal['Ingredients ']}");
                                          return MealDetailCard(
                                            textColor: Colors.white,
                                            title: meal['Menu Item'],
                                            imagePath: meal['Images'],
                                            replaceCard: false,
                                            nutritionInfo: {
                                              "Calories":
                                                  "${meal['Calories']} Kcal",
                                              "Protein": "${meal['Protein']} g",
                                              "Carbs": "${meal['Carbs']} g",
                                              "Fat": "${meal['Fat']} g",
                                            },
                                            ingredients: meal['Ingredients'],
                                            servingSize:
                                                "Serving size information",
                                            buttonText:
                                                "Replace with another Meal",
                                            onPressedBandS: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return MealReplaceOptions(
                                                    breakfastSnack: true,
                                                    currentMealId: meal['id'],
                                                    jsonFilePath:
                                                        'assets/sorted_distances.json',
                                                    onMealSelected:
                                                        (selectedMealId) async {
                                                      // Fetch the details of the selected meal
                                                      String data = await rootBundle
                                                          .loadString(
                                                              'assets/rfg_updated.json');
                                                      List<dynamic> meals =
                                                          jsonDecode(data);
                                                      var selectedMeal =
                                                          meals.firstWhere(
                                                              (meal) =>
                                                                  meal['id'] ==
                                                                  selectedMealId,
                                                              orElse: () => {});

                                                      // Update the mealDetails with the selected meal
                                                      setState(() {
                                                        mealDetails =
                                                            mealDetails
                                                                .map((m) {
                                                          if (m['id'] ==
                                                              meal['id']) {
                                                            return selectedMeal
                                                                as Map<String,
                                                                    dynamic>;
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
                                                builder:
                                                    (BuildContext context) {
                                                  return MealReplaceOptions(
                                                    breakfastSnack: false,
                                                    currentMealId: meal['id'],
                                                    jsonFilePath:
                                                        'assets/sorted_distances.json',
                                                    onMealSelected:
                                                        (selectedMealId) async {
                                                      // Fetch the details of the selected meal
                                                      String data = await rootBundle
                                                          .loadString(
                                                              'assets/rfg_updated.json');
                                                      List<dynamic> meals =
                                                          jsonDecode(data);
                                                      var selectedMeal =
                                                          meals.firstWhere(
                                                              (meal) =>
                                                                  meal['id'] ==
                                                                  selectedMealId,
                                                              orElse: () => {});

                                                      // Update the mealDetails with the selected meal
                                                      setState(() {
                                                        mealDetails =
                                                            mealDetails
                                                                .map((m) {
                                                          if (m['id'] ==
                                                              meal['id']) {
                                                            return selectedMeal
                                                                as Map<String,
                                                                    dynamic>;
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
                                      );
                                    } else {
                                      return Stack(children: [
                                        SingleChildScrollView(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: mealDetails.map((meal) {
                                              // print("Ingredients: ${meal['Ingredients ']}");
                                              return MealDetailCard(
                                                textColor: Colors.white,
                                                title: meal['Menu Item'],
                                                imagePath: meal['Images'],
                                                replaceCard: false,
                                                nutritionInfo: {
                                                  "Calories":
                                                      "${meal['Calories']} Kcal",
                                                  "Protein":
                                                      "${meal['Protein']} g",
                                                  "Carbs": "${meal['Carbs']} g",
                                                  "Fat": "${meal['Fat']} g",
                                                },
                                                ingredients:
                                                    meal['Ingredients'],
                                                servingSize:
                                                    "Serving size information",
                                                buttonText:
                                                    "Replace with another Meal",
                                                onPressedBandS: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return MealReplaceOptions(
                                                        breakfastSnack: true,
                                                        currentMealId:
                                                            meal['id'],
                                                        jsonFilePath:
                                                            'assets/sorted_distances.json',
                                                        onMealSelected:
                                                            (selectedMealId) async {
                                                          // Fetch the details of the selected meal
                                                          String data =
                                                              await rootBundle
                                                                  .loadString(
                                                                      'assets/rfg_updated.json');
                                                          List<dynamic> meals =
                                                              jsonDecode(data);
                                                          var selectedMeal =
                                                              meals.firstWhere(
                                                                  (meal) =>
                                                                      meal[
                                                                          'id'] ==
                                                                      selectedMealId,
                                                                  orElse: () =>
                                                                      {});

                                                          // Update the mealDetails with the selected meal
                                                          setState(() {
                                                            mealDetails =
                                                                mealDetails
                                                                    .map((m) {
                                                              if (m['id'] ==
                                                                  meal['id']) {
                                                                return selectedMeal
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return MealReplaceOptions(
                                                        breakfastSnack: false,
                                                        currentMealId:
                                                            meal['id'],
                                                        jsonFilePath:
                                                            'assets/sorted_distances.json',
                                                        onMealSelected:
                                                            (selectedMealId) async {
                                                          // Fetch the details of the selected meal
                                                          String data =
                                                              await rootBundle
                                                                  .loadString(
                                                                      'assets/rfg_updated.json');
                                                          List<dynamic> meals =
                                                              jsonDecode(data);
                                                          var selectedMeal =
                                                              meals.firstWhere(
                                                                  (meal) =>
                                                                      meal[
                                                                          'id'] ==
                                                                      selectedMealId,
                                                                  orElse: () =>
                                                                      {});

                                                          // Update the mealDetails with the selected meal
                                                          setState(() {
                                                            mealDetails =
                                                                mealDetails
                                                                    .map((m) {
                                                              if (m['id'] ==
                                                                  meal['id']) {
                                                                return selectedMeal
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;
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
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                _scrollController.animateTo(
                                                  _scrollController.offset -
                                                      300,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              child: Container(
                                                color: Colors.black54,
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                _scrollController.animateTo(
                                                  _scrollController.offset +
                                                      300,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              child: Container(
                                                color: Colors.black54,
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
