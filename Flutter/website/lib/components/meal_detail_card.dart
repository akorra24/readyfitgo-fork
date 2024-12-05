import 'package:flutter/material.dart';

class MealDetailCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Map<String, String> nutritionInfo;
  final String servingSize; // You can remove this if no longer needed
  final Color textColor;
  final String ingredients;
  final bool replaceCard;
  final VoidCallback? onPressed;
  final VoidCallback? onPressedBandS;

  final String buttonText;

  const MealDetailCard({
    Key? key,
    required this.title,
    required this.replaceCard,
    required this.imagePath,
    required this.nutritionInfo,
    required this.servingSize,
    required this.textColor,
    required this.ingredients,
    this.onPressed,
    this.onPressedBandS,
    this.buttonText = 'Replace',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 300, maxHeight: 700), // Ensure consistent size
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: textColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                'http://localhost:5000/image-proxy?url=$imagePath',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Failed to load image');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textColor),
                    ),
                  ),
                  const Divider(),
                  ...nutritionInfo.entries.map((entry) => Column(
                        children: [
                          _buildTableRow(entry.key, entry.value),
                          const Divider(),
                        ],
                      )),
                  const SizedBox(height: 8),
                  // Replacing Serving Size with Ingredients and hover/touch interaction
                  _buildIngredientHover(context), // Pass the context here
                ],
              ),
            ),
            replaceCard
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: onPressedBandS ?? () {},
                      child: const Text(
                        'Replace w/ Snack/Breakfast',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            replaceCard
                ? Container()
                : Divider(
                    color: textColor,
                  ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: onPressed ?? () {},
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor),
        ),
        Text(
          value,
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }

  // Widget to handle hover/touch for ingredients
  Widget _buildIngredientHover(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context, // Use the passed context here
          builder: (context) => AlertDialog(
            title: const Text('Ingredients'),
            content: Container(
              constraints: const BoxConstraints(maxWidth: 350), // Set max width
              child: SingleChildScrollView(
                child: Text(ingredients),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Align(
          alignment: Alignment.center,
          child: Tooltip(
            message: 'Tap to view ingredients',
            child: Text(
              "Ingredients: ${_shortenIngredients(ingredients)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Shorten ingredients for preview
  String _shortenIngredients(String ingredients) {
    if (ingredients.length > 50) {
      return '${ingredients.substring(0, 50)}...';
    } else {
      return ingredients;
    }
  }
}
