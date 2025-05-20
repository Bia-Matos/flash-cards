class Collection {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<String> flashcardIds; // IDs dos flashcards nesta coleção

  Collection({
    required this.id,
    required this.name,
    List<String>? flashcardIds,
    DateTime? createdAt,
  }) : 
    this.flashcardIds = flashcardIds ?? [],
    this.createdAt = createdAt ?? DateTime.now();

  // Convertendo de e para Map (para persistência)
  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'],
      name: map['name'],
      flashcardIds: List<String>.from(map['flashcardIds'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'flashcardIds': flashcardIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 