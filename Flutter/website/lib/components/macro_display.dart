import 'package:flutter/material.dart';

class MacroBarDisplayWidget extends StatelessWidget {
  final String calories;
  final String carbs;
  final String protein;
  final String fats;
  final Color borderColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool button;

  const MacroBarDisplayWidget({
    Key? key,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.button = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMacroColumn('Calories', calories, 'cal'),
          _buildMacroColumn('Carbs', carbs, 'g'),
          _buildMacroColumn('Protein', protein, 'g'),
          _buildMacroColumn('Fats', fats, 'g'),
          button
              ? GestureDetector(
                  onTap: onPressed ?? () {},
                  child: SizedBox(
                    width: 130,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildMacroColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontSize: 13),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(color: textColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
