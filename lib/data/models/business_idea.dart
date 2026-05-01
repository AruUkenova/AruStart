class BusinessIdea {
  final String id;
  final String title;
  final String category;
  final String description;

  BusinessIdea({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
    };
  }

  factory BusinessIdea.fromMap(Map map) {
    return BusinessIdea(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
    );
  }
}