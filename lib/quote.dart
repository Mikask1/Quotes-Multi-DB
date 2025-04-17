class Quote {
  String text;
  String id;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  String? imagePath;
  
  Quote({ 
    required this.text,
    required this.id,
    required this.userId,
    required this.createdAt, 
    required this.updatedAt,
    this.imagePath,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'imagePath': imagePath,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      text: map['text'],
      userId: map['userId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      imagePath: map['imagePath'],
    );
  }
}