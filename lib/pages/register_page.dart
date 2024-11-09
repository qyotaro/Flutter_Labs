import 'package:flutter/material.dart';
import 'package:flutter_project/logic/user_repo.dart';
import 'package:flutter_project/logic/user_repo_maneger.dart';
import 'package:flutter_project/utils/responsive_config.dart';
import 'package:flutter_project/widgets/custom_button.dart';
import 'package:flutter_project/widgets/custom_text_button.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final UserRepository userRepository = UserRepoManeger();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> registrationUser() async {
  final email = emailController.text;
  final password = passwordController.text;
  final name = nameController.text;

  final existingUsers = await userRepository.getAllUsers();
  if (existingUsers.isNotEmpty) {
    if (!mounted) return;
    showDialog<void>(  
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 233, 241, 250), 
        title: Text(
          'Registration failed',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 17, 20, 57),
            fontSize: ResponsiveConfig.contentFontSize(context),
          ), 
        ),
        content: Text(
          'A user is already registered.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 17, 20, 57),
            fontSize: ResponsiveConfig.drawerFontSize(context),
          ), 
        ),
      ),
    );
    return;
  }

  if (!email.contains('@gmail.com') || RegExp(r'[0-9]').hasMatch(name)) {
    if (!mounted) return;
    showDialog<void>(  
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 233, 241, 250), 
        title: Text(
          'Invalid data',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 17, 20, 57),
            fontSize: ResponsiveConfig.contentFontSize(context),
          ),
        ),
        content: Text(
          'Please check your email or name.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 17, 20, 57),
            fontSize: ResponsiveConfig.drawerFontSize(context),
          ), 
        ),
      ),
    );
    return;
  }

  await userRepository.registrationUser(email, password, name);
  if (!mounted) return;

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 233, 241, 250),
      title: Text(
        'Registration Successful',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 17, 20, 57),
          fontSize: ResponsiveConfig.contentFontSize(context),
        ),
      ),
      content: Text(
        'You have successfully registered.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 17, 20, 57),
          fontSize: ResponsiveConfig.drawerFontSize(context),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color.fromARGB(255, 17, 20, 57),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    ),
  );
}


  Future<void> clearDatabase() async {
  await userRepository.clearUsers();
  if (!mounted) return;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 233, 241, 250),
      title: Text(
        'Database cleared',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 17, 20, 57),
          fontSize: ResponsiveConfig.contentFontSize(context),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveConfig.spacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: 'Name', 
              controller: nameController,
              ),
            SizedBox(height: ResponsiveConfig.spacing(context) / 2), 
            CustomTextField(
              labelText: 'Email',
              controller: emailController,
            ),
            SizedBox(height: ResponsiveConfig.spacing(context) / 2), 
            CustomTextField(
              labelText: 'Password',
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: ResponsiveConfig.spacing(context)), 
            CustomButton(
              text: 'Sign Up',
              onPressed: registrationUser,
            ),
            CustomTextButton(
              text: 'Already have an account? Sign in',
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
            SizedBox(height: ResponsiveConfig.spacing(context)), 
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                text: 'Clear database',
                onPressed: clearDatabase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
