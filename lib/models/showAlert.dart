import 'package:flutter/material.dart';

class ShowAlert{
  void showAlert(BuildContext context, String title, String content, Color color) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          backgroundColor: color,
        )
    );
  }
}
