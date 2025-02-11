import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:website/components/meal_detail_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:website/components/meal_replace_options.dart';
import 'package:website/components/micro_bar_widget.dart';
import 'package:website/pages/macro_calculator_page.dart';
import 'package:website/pages/meal_generator_page.dart';

import '../models/meal_details.dart';

class MealRecommendationPage extends StatefulWidget {
  final bool isLastDay;
  final int dayIndex;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;
  final String dietaryPreference;
  final int numberOfMeals;
  final Function(List<MealDetails>) onMealDetailsUpdate;
  final List<List<MealDetails>>? allMealDetails;

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
    required this.onMealDetailsUpdate,
    this.allMealDetails,
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
      Uri.parse('https://readyfitgo-new.wl.r.appspot.com/recommend'),
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

        List<MealDetails> formattedMeals = mealDetails
            .map((meal) => MealDetails(
                mealType: meal['Meal Type'] ?? 'Breakfast',
                title: meal['Menu Item'] ?? '',
                description: '', // Add description if available in API
                imageUrl: meal['Images'] ?? '',
                ingredients: meal['Ingredients'].toString().split(','),
                instructions: [], // Add instructions if available in API
                calories: int.parse(meal['Calories']?.toString() ?? '0'),
                protein: int.parse(meal['Protein']?.toString() ?? '0'),
                carbs: int.parse(meal['Carbs']?.toString() ?? '0'),
                fat: int.parse(meal['Fat']?.toString() ?? '0'),
                day: widget.dayIndex + 1))
            .toList();

        widget.onMealDetailsUpdate(formattedMeals);
      });
    } else {
      throw Exception('Failed to load recommendations');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> generateAndDownloadPDF() async {
    final pdf = pw.Document();
    final pageWidth = PdfPageFormat.a4.width;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        header: (context) => pw.Container(
          width: pageWidth,
          color: PdfColors.blueGrey800,
          padding: pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'Your Meal Plan ',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: 'All ${widget.allMealDetails?.length} Days',
                      style: pw.TextStyle(
                        color: PdfColors.orange,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Dietary Preference: ${widget.dietaryPreference}',
                  style: pw.TextStyle(color: PdfColors.white)),
              pw.Text('Number of Meals: ${widget.numberOfMeals}',
                  style: pw.TextStyle(color: PdfColors.white)),
            ],
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(color: PdfColors.grey700),
          ),
        ),
        build: (context) => [
          // Daily Macros Target Table
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FixedColumnWidth(pageWidth * 0.25),
              1: pw.FixedColumnWidth(pageWidth * 0.25),
              2: pw.FixedColumnWidth(pageWidth * 0.25),
              3: pw.FixedColumnWidth(pageWidth * 0.25),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey800),
                children: [
                  _buildHeaderCell('Calories'),
                  _buildHeaderCell('Protein'),
                  _buildHeaderCell('Carbs'),
                  _buildHeaderCell('Fat'),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildDataCell('${widget.calories}'),
                  _buildDataCell('${widget.protein}g'),
                  _buildDataCell('${widget.carbs}g'),
                  _buildDataCell('${widget.fats}g'),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Meal Schedule Table
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FixedColumnWidth(80),
              for (var i = 1; i <= widget.allMealDetails!.length; i++)
                i: pw.FixedColumnWidth(
                    (pageWidth - 100) / widget.allMealDetails!.length),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey800),
                children: [
                  _buildHeaderCell('Meal'),
                  for (var i = 0; i < widget.allMealDetails!.length; i++)
                    _buildHeaderCell('Day ${i + 1}'),
                ],
              ),
              // Meal rows
              for (var mealIndex = 0;
                  mealIndex < widget.allMealDetails![0].length;
                  mealIndex++)
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.blueGrey800,
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Meal ${mealIndex + 1}',
                        style: pw.TextStyle(color: PdfColors.white),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    for (var dayIndex = 0;
                        dayIndex < widget.allMealDetails!.length;
                        dayIndex++)
                      _buildMealCell(
                          widget.allMealDetails![dayIndex][mealIndex]),
                  ],
                ),
              // Add total row
              pw.TableRow(
                children: [
                  pw.Container(
                    color: PdfColors.blueGrey800,
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  for (var dayIndex = 0;
                      dayIndex < widget.allMealDetails!.length;
                      dayIndex++)
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Daily Totals',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ...(() {
                            final totals = _calculateDayTotals(
                                widget.allMealDetails![dayIndex]);
                            return [
                              pw.Text('${totals['calories']?.round()} Cal'),
                              pw.Text('P: ${totals['protein']?.round()}g'),
                              pw.Text('C: ${totals['carbs']?.round()}g'),
                              pw.Text('F: ${totals['fat']?.round()}g'),
                            ];
                          })(),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return pdf.save();
      },
      name: 'meal_plan.pdf',
      format: PdfPageFormat.a4.copyWith(
        marginLeft: 20,
        marginRight: 20,
        marginTop: 20,
        marginBottom: 20,
      ),
    );
  }

// Helper methods

  Map<String, double> _calculateDayTotals(List<MealDetails> dayMeals) {
    return {
      'calories': dayMeals.fold(0.0, (sum, meal) => sum + meal.calories),
      'protein': dayMeals.fold(0.0, (sum, meal) => sum + meal.protein),
      'carbs': dayMeals.fold(0.0, (sum, meal) => sum + meal.carbs),
      'fat': dayMeals.fold(0.0, (sum, meal) => sum + meal.fat),
    };
  }

  pw.Widget _buildHeaderCell(String text) => pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          style: pw.TextStyle(color: PdfColors.white),
          textAlign: pw.TextAlign.center,
        ),
      );

  pw.Widget _buildDataCell(String text) => pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text(text, textAlign: pw.TextAlign.center),
      );

  pw.Widget _buildMealCell(MealDetails meal) => pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(meal.title,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('${meal.calories} Cal'),
            pw.Text('P: ${meal.protein}g'),
            pw.Text('C: ${meal.carbs}g'),
            pw.Text('F: ${meal.fat}g'),
          ],
        ),
      );

  // Send Email function
  Future<void> sendEmail(String email) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbyBf2rzDicQoC9LuOL-YG8S4s5XLMqgfpKP8V-Tr5jzroudBQ2cEsvEWe4FLBOL2Vs5/exec'),
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
        "meal_info": widget.allMealDetails
                ?.map((dayMeals) => dayMeals
                    .map((meal) => {
                          "mealType": meal.mealType,
                          "title": meal.title,
                          "calories": meal.calories,
                          "protein": meal.protein,
                          "carbs": meal.carbs,
                          "fat": meal.fat,
                          "imageUrl": meal.imageUrl,
                          "ingredients": meal.ingredients.join(','),
                          "day": meal.day
                        })
                    .toList())
                .toList() ??
            [],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MacroCalculatorPage()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Your Daily Meal Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    // Add invisible widget to maintain centering
                    SizedBox(width: 68), // Same width as IconButton + padding
                  ],
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
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (constraints.maxWidth < 700) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              // Email Button
                                              OutlinedButton.icon(
                                                onPressed: widget.isLastDay
                                                    ? () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF0B1D26),
                                                              title: const Text(
                                                                'Enter Email',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    _emailController,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Enter your email',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (_emailController
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      sendEmail(_emailController
                                                                              .text)
                                                                          .then(
                                                                              (_) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Text('Email sent successfully!'),
                                                                          ),
                                                                        );

                                                                        _emailController
                                                                            .clear();
                                                                      }).catchError(
                                                                              (error) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text('Failed to send email: $error'),
                                                                          ),
                                                                        );
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
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
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  backgroundColor:
                                                      widget.isLastDay
                                                          ? Colors.black
                                                          : Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Adjust radius value as needed
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              OutlinedButton.icon(
                                                onPressed: widget.isLastDay
                                                    ? generateAndDownloadPDF
                                                    : () {},
                                                icon: Icon(Icons.print_outlined,
                                                    color: Colors.white),
                                                label: Text(
                                                  'Print',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  backgroundColor:
                                                      widget.isLastDay
                                                          ? Colors.black
                                                          : Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Adjust radius value as needed
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Shop now Button
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              html.window.open(
                                                  'https://readyfitgo.com/shop',
                                                  '_blank');
                                            },
                                            icon: Icon(
                                                Icons.shopping_cart_outlined,
                                                color: Colors.white),
                                            label: Text(
                                              'Shop Now',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.transparent),
                                              backgroundColor: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Regenerate Button
                                          OutlinedButton.icon(
                                            onPressed: fetchRecommendedMeals,
                                            icon: Icon(Icons.refresh,
                                                color: Colors.white),
                                            label: Text(
                                              'Regenerate',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.transparent),
                                              backgroundColor: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              // Email Button
                                              OutlinedButton.icon(
                                                onPressed: widget.isLastDay
                                                    ? () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF0B1D26),
                                                              title: const Text(
                                                                'Enter Email',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    _emailController,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Enter your email',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (_emailController
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      sendEmail(_emailController
                                                                              .text)
                                                                          .then(
                                                                              (_) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Text('Email sent successfully!'),
                                                                          ),
                                                                        );

                                                                        _emailController
                                                                            .clear();
                                                                      }).catchError(
                                                                              (error) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text('Failed to send email: $error'),
                                                                          ),
                                                                        );
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
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
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  backgroundColor:
                                                      widget.isLastDay
                                                          ? Colors.black
                                                          : Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Adjust radius value as needed
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              OutlinedButton.icon(
                                                onPressed: widget.isLastDay
                                                    ? generateAndDownloadPDF
                                                    : () {},
                                                icon: Icon(Icons.print_outlined,
                                                    color: Colors.white),
                                                label: Text(
                                                  'Print',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  backgroundColor:
                                                      widget.isLastDay
                                                          ? Colors.black
                                                          : Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Adjust radius value as needed
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Shop now Button
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              html.window.open(
                                                  'https://readyfitgo.com/shop',
                                                  '_blank');
                                            },
                                            icon: Icon(
                                                Icons.shopping_cart_outlined,
                                                color: Colors.white),
                                            label: Text(
                                              'Shop Now',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.transparent),
                                              backgroundColor: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
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
                                          print("Ingredients: ${meal}");
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

                                                        List<MealDetails> formattedMeals = mealDetails
                                                            .map((meal) => MealDetails(
                                                                mealType: meal['Meal Type'] ?? 'Breakfast',
                                                                title: meal['Menu Item'] ?? '',
                                                                description: '', // Add description if available in API
                                                                imageUrl: meal['Images'] ?? '',
                                                                ingredients: meal['Ingredients'].toString().split(','),
                                                                instructions: [], // Add instructions if available in API
                                                                calories: int.parse(meal['Calories']?.toString() ?? '0'),
                                                                protein: int.parse(meal['Protein']?.toString() ?? '0'),
                                                                carbs: int.parse(meal['Carbs']?.toString() ?? '0'),
                                                                fat: int.parse(meal['Fat']?.toString() ?? '0'),
                                                                day: widget.dayIndex + 1))
                                                            .toList();

                                                        widget
                                                            .onMealDetailsUpdate(
                                                                formattedMeals);
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

                                                        List<MealDetails> formattedMeals = mealDetails
                                                            .map((meal) => MealDetails(
                                                                mealType: meal['Meal Type'] ?? 'Breakfast',
                                                                title: meal['Menu Item'] ?? '',
                                                                description: '', // Add description if available in API
                                                                imageUrl: meal['Images'] ?? '',
                                                                ingredients: meal['Ingredients'].toString().split(','),
                                                                instructions: [], // Add instructions if available in API
                                                                calories: int.parse(meal['Calories']?.toString() ?? '0'),
                                                                protein: int.parse(meal['Protein']?.toString() ?? '0'),
                                                                carbs: int.parse(meal['Carbs']?.toString() ?? '0'),
                                                                fat: int.parse(meal['Fat']?.toString() ?? '0'),
                                                                day: widget.dayIndex + 1))
                                                            .toList();

                                                        widget
                                                            .onMealDetailsUpdate(
                                                                formattedMeals);
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
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

                                                            List<MealDetails> formattedMeals = mealDetails
                                                                .map((meal) => MealDetails(
                                                                    mealType: meal['Meal Type'] ?? 'Breakfast',
                                                                    title: meal['Menu Item'] ?? '',
                                                                    description: '', // Add description if available in API
                                                                    imageUrl: meal['Images'] ?? '',
                                                                    ingredients: meal['Ingredients'].toString().split(','),
                                                                    instructions: [], // Add instructions if available in API
                                                                    calories: int.parse(meal['Calories']?.toString() ?? '0'),
                                                                    protein: int.parse(meal['Protein']?.toString() ?? '0'),
                                                                    carbs: int.parse(meal['Carbs']?.toString() ?? '0'),
                                                                    fat: int.parse(meal['Fat']?.toString() ?? '0'),
                                                                    day: widget.dayIndex + 1))
                                                                .toList();

                                                            widget.onMealDetailsUpdate(
                                                                formattedMeals);
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

                                                            List<MealDetails> formattedMeals = mealDetails
                                                                .map((meal) => MealDetails(
                                                                    mealType: meal['Meal Type'] ?? 'Breakfast',
                                                                    title: meal['Menu Item'] ?? '',
                                                                    description: '', // Add description if available in API
                                                                    imageUrl: meal['Images'] ?? '',
                                                                    ingredients: meal['Ingredients'].toString().split(','),
                                                                    instructions: [], // Add instructions if available in API
                                                                    calories: int.parse(meal['Calories']?.toString() ?? '0'),
                                                                    protein: int.parse(meal['Protein']?.toString() ?? '0'),
                                                                    carbs: int.parse(meal['Carbs']?.toString() ?? '0'),
                                                                    fat: int.parse(meal['Fat']?.toString() ?? '0'),
                                                                    day: widget.dayIndex + 1))
                                                                .toList();

                                                            widget.onMealDetailsUpdate(
                                                                formattedMeals);
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
