import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/bottom_navigation.dart';
import 'package:flutter_project/logic/books.dart';
import 'package:flutter_project/logic/books_repo_maneger.dart';
import 'package:flutter_project/utils/responsive_config.dart';
import 'package:flutter_project/widgets/custom_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final BooksRepoManeger bookRepository = BooksRepoManeger();
  List<Book> books = [];
  final TextEditingController booksController = TextEditingController();
  late StreamSubscription<List<ConnectivityResult>> subscription; 
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();

    subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> resultList) {
      if (resultList.isNotEmpty && resultList.contains(ConnectivityResult.none))
      {
        setState(() {
          _isOffline = true;
        });
        _showConnectionLostDialog();
      } else {
        setState(() {
          _isOffline = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkConnectivity(); 
  }

  @override
  void dispose() {
    subscription.cancel();
    booksController.dispose(); 
    super.dispose();
  }


  void _checkConnectivity() {
    Connectivity().checkConnectivity().then((connectivityResult) {
      // ignore: unrelated_type_equality_checks
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isOffline = true;
        });
        _showConnectionLostDialog();
      } else {
        setState(() {
          _isOffline = false;
        });
      }
    });
  }

  Future<void> _loadBooks() async {
    final loadedBooks = await bookRepository.getAllBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  Future<void> _addBookDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController currentPageController = TextEditingController();
    final TextEditingController totalPagesController = TextEditingController();
  
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Book Title'),
              ),
              TextField(
                controller: currentPageController,
                decoration: const InputDecoration(hintText: 'Current Page'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalPagesController,
                decoration: const InputDecoration(hintText: 'Total Pages'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String title = titleController.text;
                final int currentPage =
                 int.tryParse(currentPageController.text) ?? 0;
                final int totalPages =
                 int.tryParse(totalPagesController.text) ?? 0;

                if (_isOffline) {
                   _showErrorDialog('No internet connection.' 
                   'Please check your internet connection and try again.');
                } else if (title.isNotEmpty && totalPages >
                 0 && currentPage <= totalPages) {
                  final newBook = Book(
                    title: title,
                    currentPage: currentPage,
                    totalPages: totalPages,
                  );
                  await bookRepository.addBook(newBook);
                   if (context.mounted) {
                  _loadBooks();
                  Navigator.of(context).pop();
                  }
                } else {
                  _showErrorDialog(
                    'Please enter valid book details and' 
                    'ensure current page does not exceed total pages.',
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editBookDialog(Book book) async {
    final TextEditingController titleController =
     TextEditingController(text: book.title);
    final TextEditingController currentPageController =
     TextEditingController(text: book.currentPage.toString());
    final TextEditingController totalPagesController =
     TextEditingController(text: book.totalPages.toString());

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Book Title'),
              ),
              TextField(
                controller: currentPageController,
                decoration: const InputDecoration(hintText: 'Current Page'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalPagesController,
                decoration: const InputDecoration(hintText: 'Total Pages'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final String title = titleController.text;
                final int currentPage = 
                  int.tryParse(currentPageController.text) ?? 0;
                final int totalPages = 
                  int.tryParse(totalPagesController.text) ?? 0;
                if (_isOffline) {
                 _showErrorDialog('No internet connection.' 
                  'Please check your internet connection and try again.');
                } else if (title.isNotEmpty && totalPages >
                 0 && currentPage <= totalPages) {
                  final updatedBook = Book(
                    id: book.id,
                    title: title,
                    currentPage: currentPage,
                    totalPages: totalPages,
                  );
                  await bookRepository.updateBook(updatedBook);
                  if (context.mounted) {
                    _loadBooks();
                    Navigator.of(context).pop();
                  }
                } else {
                  _showErrorDialog('Please enter valid book details and'
                   'ensure current page does not exceed total pages.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 233, 241, 250),
          title: const Text('Error', style: TextStyle(
            color: Color.fromARGB(255, 17, 20, 57),
            ),
          ),
          content: Text(message, style: const TextStyle(
            color: Color.fromARGB(255, 17, 20, 57),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(
                color: Color.fromARGB(255, 64, 184, 80),
              ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showConnectionLostDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 233, 241, 250),
          title:  Text(
            'Connection Lost',
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 20, 57),
              fontSize: ResponsiveConfig.contentFontSize(context),
            ),
          ),
          content: Text(
            'Your internet connection has been lost.',
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 20, 57),
              fontSize: ResponsiveConfig.drawerFontSize(context),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(
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

  Future<void> _toggleBookRead(Book book) async {
    final updatedBook = Book(
      id: book.id,
      title: book.title,
      currentPage: book.currentPage,
      totalPages: book.totalPages,
      isRead: !book.isRead,
    );
    await bookRepository.updateBook(updatedBook);
    _loadBooks();
  }

  Future<void> _deleteBook(int? id) async {
    if (_isOffline) {
      _showErrorDialog('No internet connection.' 
      'Please check your internet connection and try again.');
    } else if (id != null) {
      await bookRepository.deleteBook(id);
      _loadBooks();
    }
  }

    Future<void> _incrementCurrentPage(Book book) async {
    if (_isOffline) {
      _showErrorDialog('No internet connection.' 
      'Please check your internet connection and try again.');
      }  else if (book.currentPage < book.totalPages) {
      final updatedBook = Book(
        id: book.id,
        title: book.title,
        currentPage: book.currentPage + 1,
        totalPages: book.totalPages,
        isRead: book.isRead,
      );
      await bookRepository.updateBook(updatedBook);
      _loadBooks();
    } else {
      _showErrorDialog('Current page cannot exceed total pages.');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        if (_isOffline)
          Container(
            height: 60,
            color: Colors.red,
            padding:  EdgeInsets.all(ResponsiveConfig.spacing(context)/2),
            child: Text(
              'No Internet Connection',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveConfig.drawerFontSize(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
            vertical: ResponsiveConfig.spacing(context) / 2,
          ),
          child: const Divider(
            color: Color.fromARGB(255, 17, 20, 57),
            thickness: 1,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.spacing(context) / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 18,
                          color:
                           book.isRead ? Colors.green :
                           const Color.fromARGB(255, 17, 20, 57),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Current Page: ${book.currentPage} / ${book.totalPages}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                     Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              text: book.isRead ? 'Read' : 'Mark as Read',
                              onPressed: () => _toggleBookRead(book),
                            ),
                            const SizedBox(width: 4),
                            CustomButton(
                              text: '+',
                              onPressed: () => _incrementCurrentPage(book),
                            ),
                            const SizedBox(width: 4),
                            CustomButton(
                              text: 'Edit',
                              onPressed: () => _editBookDialog(book),
                            ),
                            const SizedBox(width: 4),
                            CustomButton(
                              text: 'Delete',
                              onPressed: () => _deleteBook(book.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: CustomButton(
        text: 'Add Book',
        onPressed: _addBookDialog,
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: const BottomNavigation(),
  );
}
}
