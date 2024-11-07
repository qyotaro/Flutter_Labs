import 'package:flutter/material.dart';
import 'package:flutter_project/pages/login_page.dart';
import 'package:flutter_project/pages/main_page.dart';
import 'package:flutter_project/pages/profile_page.dart';
import 'package:flutter_project/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasLoggedIn = prefs.getBool('hasLoggedIn') ?? false;

  runApp(MyApp(hasLoggedIn: hasLoggedIn));
}

class MyApp extends StatelessWidget {

  final bool hasLoggedIn;
  const MyApp({required this.hasLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 233, 241, 250),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 17, 20, 57)), 
          titleMedium: TextStyle(color: Color.fromARGB(255, 17, 20, 57)), 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(255, 17, 20, 57)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 17, 20, 57)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 17, 20, 57)),
          ),
          hintStyle: TextStyle(color: Color.fromARGB(255, 17, 20, 57)),
        ),
      ),
      initialRoute: hasLoggedIn ? '/main' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/profile': (context) => const UserProfilePage(),
        '/main': (context) =>  const MainPage(),
      },
    );
  }
}
