import 'package:flutter/material.dart';
import 'package:flutter_project/logic/user_repo_maneger.dart';
import 'package:flutter_project/utils/responsive_config.dart';
import 'package:flutter_project/widgets/custom_button.dart';
import 'package:flutter_project/widgets/custom_text_button.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepoManeger userRepository = UserRepoManeger();

  LoginPage({super.key});

  Future<void> loginUser(BuildContext context) async {
  final email = emailController.text;
  final password = passwordController.text;

  final user = await userRepository.loginUser(email, password);
  if (context.mounted) { 
    if (user != null) {
      Navigator.pushNamed(context, '/profile');
    } else {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 233, 241, 250),
          title: Text(
            'Login failed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 20, 57),
              fontSize: ResponsiveConfig.contentFontSize(context),
            ),
          ),
          content: Text(
            'Invalid email or password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 20, 57),
              fontSize: ResponsiveConfig.drawerFontSize(context),
            ),
          ),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ResponsiveConfig.spacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
            ),
            SizedBox(height: ResponsiveConfig.spacing(context) / 2),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: ResponsiveConfig.spacing(context)),
            CustomButton(
              text: 'Sign in',
              onPressed: () => loginUser(context),
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
