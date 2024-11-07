class Book {
  final int? id;
  final String title;
  final int currentPage;
  final int totalPages;
  final bool isRead;

  Book({
    required this.title,
    required this.totalPages,
    this.currentPage = 0,
    this.id,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String,
      currentPage: map['currentPage'] as int,
      totalPages: map['totalPages'] as int,
      isRead: map['isRead'] == 1,
    );
  }
}
