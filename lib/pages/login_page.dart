import 'package:flutter/material.dart';
import 'package:flutter_project/utils/responsive_config.dart';
import 'package:flutter_project/widgets/custom_button.dart';
import 'package:flutter_project/widgets/custom_text_button.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ResponsiveConfig.spacing(context)), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const CustomTextField(labelText: 'Email'),
            SizedBox(height: ResponsiveConfig.spacing(context) / 2),
            const CustomTextField(labelText: 'Password', obscureText: true),
            SizedBox(height: ResponsiveConfig.spacing(context)), 
            CustomButton(
              text: 'Sign in',
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
            ),
            CustomTextButton(
              text: 'Don\'t have an account? Sign up',
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}
