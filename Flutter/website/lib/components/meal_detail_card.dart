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
    this.buttonText = 'Replace with another Meal',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: 300, maxHeight: 700), // Ensure consistent size
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // border: Border.all(color: textColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: replaceCard
                ? [Color(0xFF162D37), Color(0x6E162E38)]
                : [Color(0xFF162D37), Color(0xFF42545C), Colors.white],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                'https://readyfitgo-fork.onrender.com/image-proxy?url=$imagePath',
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
                          color: Colors.white),
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
                : Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF4DADB3),
                          borderRadius: BorderRadius.circular(50)),
                      height: 35,
                      width: 200,
                      child: TextButton(
                        onPressed: onPressedBandS ?? () {},
                        child: const Text(
                          'Replace with Breakfast/Snack',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            replaceCard
                ? Container()
                : SizedBox(
                    height: 15,
                  ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: replaceCard ? Color(0xFF68B268) : Color(0xFFFF8E3C),
                    borderRadius: BorderRadius.circular(50)),
                height: 35,
                width: 200,
                child: TextButton(
                  onPressed: onPressed ?? () {},
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            replaceCard
                ? Container()
                : SizedBox(
                    height: 20,
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
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
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
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              height: 35,
              width: 150,
              child: Center(
                child: Text(
                  'View Ingredients',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
