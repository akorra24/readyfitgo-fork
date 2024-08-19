import 'package:flutter/material.dart';

class MealDetailCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Map<String, String> nutritionInfo;
  final String servingSize;
  final VoidCallback? onPressed;
  final String buttonText;
  // final bool button;

  const MealDetailCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.nutritionInfo,
    required this.servingSize,
    this.onPressed,
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
          border: Border.all(color: Colors.white, width: 1),
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
                  'http://localhost:3000/image-proxy?url=$imagePath',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Text('Failed to load image');
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Divider(),
                  ...nutritionInfo.entries.map((entry) => Column(
                        children: [
                          _buildTableRow(entry.key, entry.value),
                          const Divider(),
                        ],
                      )),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Serving: $servingSize",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: onPressed ??
                    () {}, // Use the passed function or a default empty function
                child: Text(
                  buttonText, // Use the passed text or the default
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
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
