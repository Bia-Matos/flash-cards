import 'package:flutter/material.dart';
import '../models/collection_model.dart';
import '../services/flashcard_service.dart';
import '../widgets/flashcard_widget.dart';
import 'create_card_screen.dart';

class CollectionDetailScreen extends StatelessWidget {
  final Collection collection;

  const CollectionDetailScreen({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
      ),
      body: AnimatedBuilder(
        animation: FlashcardService.instance,
        builder: (context, child) {
          final flashcards = FlashcardService.instance.getFlashcardsFromCollection(collection.id);

          if (flashcards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.style,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum cartão nesta coleção',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar um flashcard',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho da coleção
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collection.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${flashcards.length} ${flashcards.length == 1 ? 'cartão' : 'cartões'}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lista de flashcards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.5,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      return FlashcardWidget(flashcard: flashcards[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCardScreen(collectionId: collection.id),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 