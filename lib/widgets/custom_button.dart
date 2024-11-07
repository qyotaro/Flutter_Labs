import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Color.fromARGB(255, 233, 241, 250)),
        ),
      ),
    );
  }
}
