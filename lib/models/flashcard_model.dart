class Flashcard {
  final String id;
  final String front; // Palavra/frase em alemão
  final String back;  // Tradução em português
  final DateTime createdAt;
  
  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
  
  // Convertendo de e para Map (útil para persistência posterior)
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      front: map['front'],
      back: map['back'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 