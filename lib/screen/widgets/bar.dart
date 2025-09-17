import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 4,
      iconTheme: IconThemeData(color: Colors.blueAccent),
      actions: actions, // íconos de back en azul
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
