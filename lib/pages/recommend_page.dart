import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/utils/responsive_config.dart'; // Додано імпорт для адаптивності
import 'package:http/http.dart' as http;

class RecommendedBookPage extends StatelessWidget {
  const RecommendedBookPage({super.key});

  Future<List<Map<String, String>>> fetchWantToReadBooks() async {
    const String apiUrl = 'https://openlibrary.org/people/mekBot/books/want-to-read.json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;

        final List<dynamic>? entries = data['reading_log_entries'] as List<dynamic>?;
        if (entries == null || entries.isEmpty) {
          return [];
        }

        return entries.map<Map<String, String>>((entry) { // Додаємо явне зазначення типу для колекції
          final Map<String, dynamic> work = (entry['work'] ?? {}) as Map<String, dynamic>;
          return {
            'title': work['title'] is String ? work['title'] as String : 'Unknown Title',
            'author': work['author_names'] is List && (work['author_names'] as List).isNotEmpty
                ? (work['author_names'] as List)[0] as String
                : 'Unknown Author',
          };
        }).toList();
      } else {
        throw Exception('Failed to load want-to-read books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Want to Read Books'),
      ),
      body: FutureBuilder<List<Map<String, String>>>( 
        future: fetchWantToReadBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && (snapshot.data?.isNotEmpty == true)) {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(
                    book['title']!,
                    style: TextStyle(
                      fontSize: ResponsiveConfig.contentFontSize(context) / 1.2,  
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 17, 20, 57),  
                    ),
                  ),
                  subtitle: Text(
                    'by ${book['author']}',
                    style: TextStyle(
                      fontSize: ResponsiveConfig.drawerFontSize(context) / 1.1,
                      color: const Color.fromARGB(255, 17, 20, 57),  
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No books available'));
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 233, 241, 250),  // Колір фону
    );
  }
}
