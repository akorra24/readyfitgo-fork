import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final double height;

  CustomAppBar({required this.title, this.showLogo = true, this.height = 80.0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFFF5E1),
      title: Padding(
        padding: const EdgeInsets.only(left: 9, top: 9),
        child: Row(
          children: [
            if (showLogo)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'images/logo1.png', // Replace with your logo image path
                  height: height * 0.99, // Adjust the height of the logo
                ),
              ),
          ],
        ),
      ),
      toolbarHeight: height, // Set the height of the AppBar
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
