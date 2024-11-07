import 'package:flutter/material.dart';
import 'package:flutter_project/bottom_navigation.dart';
import 'package:flutter_project/logic/user_repo_maneger.dart';
import 'package:flutter_project/utils/responsive_config.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserRepoManeger userRepository = UserRepoManeger();
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    final users = await userRepository.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userName = users.first['name'] as String?; 
        userEmail = users.first['email'] as String?; 
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
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
                'Name: $userName',
                style: TextStyle(
                  fontSize: ResponsiveConfig.fontSizeName(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveConfig.spacing(context) / 2),
              Text(
                'Email: $userEmail',
                style: TextStyle(
                    fontSize: ResponsiveConfig.fontSizeEmail(context),),
              ),
              SizedBox(height: ResponsiveConfig.spacing(context)),
              TextButton(
                onPressed: () async {
                  final shouldLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 233, 241, 250),
                      title: Text(
                        'Log out',
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          color:  const Color.fromARGB(255, 17, 20, 57),
                          fontSize: ResponsiveConfig.contentFontSize(context),
                          ),
                        ),
                      content: Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 17, 20, 57),
                          fontSize: ResponsiveConfig.drawerFontSize(context),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); 
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color.fromARGB(255, 17, 83, 31),

                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); 
                          },
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              color: Color.fromARGB(255, 207, 44, 58),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                   if (mounted && shouldLogout == true) {
                    await userRepository.logoutUser();  
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); 
                  }
                },
                child: Text(
                  'Log out',
                   style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveConfig.drawerFontSize(context),
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
