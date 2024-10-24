import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Program Finder';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  String _result = '';

  final Map<String, String> _programs = {
    'windows': 'Microsoft',
    'word': 'Microsoft',
    'excel': 'Microsoft',
    'powerpoint': 'Microsoft',
    'chrome': 'Google',
    'gmail': 'Google',
    'youtube': 'Google',
    'discord': 'Discord Inc.',
    'android': 'Google',
    'macos': 'Apple',
    'ios': 'Apple',
    'photoshop': 'Adobe',
    'zoom': 'Zoom Video Communications',
    'deadlock': 'Valve Corporation',
    'dota 2': 'Valve Corporation',
    'minecraft' : 'Mojang Studios',

  };


void _findCompany() {
  setState(() {
    final String program = _controller.text.trim().toLowerCase(); 
    if (_programs.containsKey(program)) {
      _result = 'Program "$program" was created by ${_programs[program]}.';
    } else {
      _result = 'Program "$program" not found in the database.';
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Program Finder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 75,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: 'Enter program name',
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            ElevatedButton(
              onPressed: _findCompany,
              child: const Text('Find Company'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
