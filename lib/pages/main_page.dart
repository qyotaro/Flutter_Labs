import 'package:flutter/material.dart';
import 'package:flutter_project/bottom_navigation.dart';
import 'package:flutter_project/utils/responsive_config.dart'; 
import 'package:flutter_project/widgets/custom_button.dart'; // Не забудьте імпортувати ваш CustomButton

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: ResponsiveConfig.spacing(context)), 
            child: Text(
              'List of books',
              style: TextStyle(
                fontSize: ResponsiveConfig.contentFontSize(context), 
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 17, 20, 57),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveConfig.spacing(context)/2,
              ), 
            child: const Divider(
              color: Color.fromARGB(255, 17, 20, 57),
              thickness: 1,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'List of books and their reading progress',
                style: TextStyle(
                  fontSize: ResponsiveConfig.contentFontSize(context), 
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56), 
        child: CustomButton(
          text: 'Add New Book',
          onPressed: () {
            
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
