import 'package:flutter/material.dart';
import '../widgets/flashcard_list.dart';
import '../screens/create_card_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alemão Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Implementar tela de informações no futuro
            },
          ),
        ],
      ),
      body: const FlashcardList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCardScreen()),
          );
        },
      ),
    );
  }
} 