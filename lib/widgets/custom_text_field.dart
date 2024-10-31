import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

 const CustomTextField({
  required this.labelText,
  required this.controller,
  super.key,
  this.obscureText = false,
});


  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      style: const TextStyle(color: Color.fromARGB(255, 17, 20, 57)),
    );
  }
}
