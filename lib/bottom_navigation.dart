
import 'package:flutter/material.dart';
import 'package:flutter_project/utils/responsive_config.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = ResponsiveConfig.iconSize(context); 
    final double padding = ResponsiveConfig.spacing(context) * 2; 

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
           GestureDetector(
            onTap: () {
              //soon
            },
            child: Image.asset(
              'assets/data.png',
              height: iconSize, 
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/main'); 
            },
            child: Image.asset(
              'assets/books.png',
              height: iconSize, 
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile'); 
            },
            child: Image.asset(
              'assets/user.png',
              height: iconSize, 
            ),
          ),
        ],
      ),
    );
  }
}
