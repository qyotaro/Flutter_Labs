import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/logic/user_repo_maneger.dart';
import 'package:flutter_project/utils/responsive_config.dart';
import 'package:flutter_project/widgets/custom_button.dart';
import 'package:flutter_project/widgets/custom_text_button.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepoManeger userRepository = UserRepoManeger();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult> result) {
      setState(() {
        isConnected = result.isNotEmpty && result.first != 
          ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
  if (!isConnected) {
    if (context.mounted) {
      showDialog<void>(  
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 233, 241, 250),
            title: Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 17, 20, 57),
                fontSize: ResponsiveConfig.contentFontSize(context),
              ),
            ),
            content: Text(
              'Please check your internet connection and try again.',
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
                },
              ),
            ],
          );
        },
      );
    }
  } else {
    final email = emailController.text;
    final password = passwordController.text;
    final user = await userRepository.loginUser(email, password);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasLoggedIn', true);
      if (context.mounted) {
        Navigator.pushNamed(context, '/profile');
      }
      if (context.mounted) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 233, 241, 250),
          title: Text(
            'Login Successful',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 20, 57),
              fontSize: ResponsiveConfig.contentFontSize(context),
            ),
          ),
          content: Text(
            'Welcome back!',
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
              },
            ),
          ],
        ),
      );
      }
    } else {
      if (context.mounted) {
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
                },
              ),
            ],
          ),
        );
      }
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
              onPressed: ()  =>  loginUser(context),
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
