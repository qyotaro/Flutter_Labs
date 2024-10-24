import 'package:flutter/material.dart';

import 'package:flutter_project/utils/responsive_config.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: ResponsiveConfig.avatarRadius(context),
                backgroundImage: const AssetImage('assets/user.png'),
              ),
              SizedBox(height: ResponsiveConfig.spacing(context)),
              Text(
                'Name: Rostyslav',
                style: TextStyle(
                  fontSize: ResponsiveConfig.fontSizeName(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveConfig.spacing(context) / 2),
              Text(
                'Email: emailtest@gmail.com',
                style: TextStyle(
                    fontSize: ResponsiveConfig.fontSizeEmail(context),),
              ),
              SizedBox(height: ResponsiveConfig.spacing(context)),
            ],
          ),
        ),
      ),
    );
  }
}
