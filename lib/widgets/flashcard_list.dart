import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/flashcard_service.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardList extends StatelessWidget {
  const FlashcardList({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: FlashcardService.instance,
      builder: (context, child) {
        final flashcards = FlashcardService.instance.flashcards;
        
        if (flashcards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.coffee,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum cartão ainda',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Toque no botão + para criar seu primeiro flashcard',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return LayoutBuilder(
          builder: (context, constraints) {
            // Layout responsivo
            final isSmallScreen = constraints.maxWidth < 600;
            final crossAxisCount = isSmallScreen ? 1 : 2;
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Seus Flashcards (${flashcards.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isSmallScreen ? 1.5 : 1.75,
                      ),
                      itemCount: flashcards.length,
                      itemBuilder: (context, index) {
                        final card = flashcards[index];
                        return FlashcardWidget(flashcard: card);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
} 