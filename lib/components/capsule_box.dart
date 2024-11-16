import 'package:flutter/material.dart';

class CapsuleBox extends StatelessWidget {
  final String text;

  const CapsuleBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 3 - 10,
      // Adjust width
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      // Adjust padding to fit font size
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius:
            BorderRadius.circular(10), // Less rounded for a more compact shape
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14), // Adjust font size if needed
        textAlign: TextAlign.center,
      ),
    );
  }
}
