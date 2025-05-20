import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';
import '../models/collection_model.dart';

class FlashcardService extends ChangeNotifier {
  static FlashcardService? _instance;
  static FlashcardService get instance {
    _instance ??= FlashcardService._internal();
    return _instance!;
  }

  FlashcardService._internal() {
    loadData();
  }

  static const String _cardsKey = 'flashcards';
  static const String _collectionsKey = 'collections';
  
  List<Flashcard> _flashcards = [];
  List<Collection> _collections = [];
  
  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
  List<Collection> get collections => List.unmodifiable(_collections);
  
  // Carregar todos os dados
  Future<void> loadData() async {
    await Future.wait([
      _loadFlashcards(),
      _loadCollections(),
    ]);
  }

  // Carregar flashcards do armazenamento
  Future<void> _loadFlashcards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cardsKey);
      
      print('Carregando flashcards do storage: $jsonString');
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _flashcards = jsonList
            .map((json) => Flashcard.fromMap(json))
            .toList();
        
        print('Flashcards carregados: ${_flashcards.length}');
      }
    } catch (e) {
      print('Erro ao carregar flashcards: $e');
    }
  }

  // Carregar coleções do armazenamento
  Future<void> _loadCollections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_collectionsKey);
      
      print('Carregando coleções do storage: $jsonString');
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _collections = jsonList
            .map((json) => Collection.fromMap(json))
            .toList();
        
        print('Coleções carregadas: ${_collections.length}');
      }
    } catch (e) {
      print('Erro ao carregar coleções: $e');
    }
  }
  
  // Salvar flashcards no armazenamento
  Future<void> _saveFlashcards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _flashcards.map((card) => card.toMap()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await prefs.setString(_cardsKey, jsonString);
      print('Flashcards salvos: ${_flashcards.length}');
    } catch (e) {
      print('Erro ao salvar flashcards: $e');
      throw Exception('Falha ao salvar os dados');
    }
  }

  // Salvar coleções no armazenamento
  Future<void> _saveCollections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _collections.map((col) => col.toMap()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await prefs.setString(_collectionsKey, jsonString);
      print('Coleções salvas: ${_collections.length}');
    } catch (e) {
      print('Erro ao salvar coleções: $e');
      throw Exception('Falha ao salvar os dados');
    }
  }
  
  // Adicionar uma nova coleção
  Future<void> addCollection(Collection collection) async {
    _collections.add(collection);
    notifyListeners();
    await _saveCollections();
  }

  // Adicionar um novo flashcard a uma coleção
  Future<void> addFlashcard(String collectionId, Flashcard card) async {
    // Adiciona o card à lista geral
    _flashcards.add(card);
    await _saveFlashcards();

    // Adiciona o ID do card à coleção
    final collectionIndex = _collections.indexWhere((col) => col.id == collectionId);
    if (collectionIndex != -1) {
      final updatedCollection = Collection(
        id: _collections[collectionIndex].id,
        name: _collections[collectionIndex].name,
        flashcardIds: [..._collections[collectionIndex].flashcardIds, card.id],
        createdAt: _collections[collectionIndex].createdAt,
      );
      _collections[collectionIndex] = updatedCollection;
      await _saveCollections();
    }
    
    notifyListeners();
  }

  // Obter flashcards de uma coleção específica
  List<Flashcard> getFlashcardsFromCollection(String collectionId) {
    final collection = _collections.firstWhere(
      (col) => col.id == collectionId,
      orElse: () => Collection(id: '', name: ''),
    );
    
    return _flashcards.where((card) => collection.flashcardIds.contains(card.id)).toList();
  }
} 