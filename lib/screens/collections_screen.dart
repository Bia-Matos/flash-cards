import 'package:flutter/material.dart';
import '../models/collection_model.dart';
import '../services/flashcard_service.dart';
import 'create_collection_screen.dart';
import 'collection_detail_screen.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Coleções'),
      ),
      body: AnimatedBuilder(
        animation: FlashcardService.instance,
        builder: (context, child) {
          final collections = FlashcardService.instance.collections;

          if (collections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma coleção ainda',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crie uma coleção para começar a adicionar flashcards',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              final cardCount = FlashcardService.instance
                  .getFlashcardsFromCollection(collection.id)
                  .length;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      collection.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(collection.name),
                  subtitle: Text(
                    '${cardCount} ${cardCount == 1 ? 'cartão' : 'cartões'}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionDetailScreen(collection: collection),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCollectionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 