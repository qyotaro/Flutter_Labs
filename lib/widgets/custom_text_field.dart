import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;

 const CustomTextField({
  required this.labelText, super.key,
  this.obscureText = false,
});


  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(labelText: labelText),
      style: const TextStyle(color: Color.fromARGB(255, 17, 20, 57)),
    );
  }
}
