import 'package:flutter/material.dart';

class MacroDisplayWidget extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final VoidCallback onPressed;

  const MacroDisplayWidget({
    Key? key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalMacros = protein + carbs + fat;
    double proteinFraction = protein / totalMacros;
    double carbsFraction = carbs / totalMacros;
    double fatFraction = fat / totalMacros;

    double targetTotalMacros = targetProtein + targetFat + targetCarbs;
    double targetProteinFraction = targetProtein / targetTotalMacros;
    double targetCarbsFraction = targetCarbs / targetTotalMacros;
    double targetFatFraction = targetFat / targetTotalMacros;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Make background transparent
          // border: Border.all(color: Colors.grey), // Add grey border
          // borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${calories.toStringAsFixed(0)} ',
                          style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Calories (Meal)'),
                    ],
                  ),
                )),
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Regenerate',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Text(
              'This bar displays the combined macros from all the recommended meals (listed below) that closely match your calculated macros.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROTEIN',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'CARBS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'FAT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: (proteinFraction * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                          ),
                          height: 10,
                        ),
                      ),
                      Expanded(
                        flex: (carbsFraction * 1000).toInt(),
                        child: Container(
                          color: Color(0xFF504CAF),
                          height: 10,
                        ),
                      ),
                      Expanded(
                        flex: (fatFraction * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFAF4C4C),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(10),
                            ),
                          ),
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${protein.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${carbs.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${fat.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8, bottom: 8),
            //   child: Text(
            //     'Target',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            //   ),
            // ),
            // SizedBox(height: 4),
            // Divider(
            //   color: Colors.grey,
            // ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '${targetCalories.toStringAsFixed(0)} ',
                      style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'Calories (Target)'),
                ],
              ),
            ),
            SizedBox(height: 3),
            Text(
              'This bar represents your personalized daily macro goals calculated from your input information.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROTEIN',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'CARBS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'FAT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: (targetProteinFraction * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                          ),
                          height: 10,
                        ),
                      ),
                      Expanded(
                        flex: (targetCarbsFraction * 1000).toInt(),
                        child: Container(
                          color: Color(0xFF504CAF),
                          height: 10,
                        ),
                      ),
                      Expanded(
                        flex: (targetFatFraction * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFAF4C4C),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(10),
                            ),
                          ),
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${targetProtein.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${targetCarbs.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${targetFat.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
