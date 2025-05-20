import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/flashcard_service.dart';

class CreateCardScreen extends StatefulWidget {
  final String collectionId;

  const CreateCardScreen({
    super.key,
    required this.collectionId,
  });

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        // Criar novo flashcard
        final newCard = Flashcard(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          front: _frontController.text.trim(),
          back: _backController.text.trim(),
        );
        
        // Salvar flashcard na coleção
        await FlashcardService.instance.addFlashcard(widget.collectionId, newCard);
        
        // Limpar o formulário e voltar
        _frontController.clear();
        _backController.clear();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cartão criado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar cartão: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Cartão'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.create,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Novo Flashcard de Alemão',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _frontController,
                  decoration: const InputDecoration(
                    labelText: 'Palavra/Frase em Alemão',
                    hintText: 'Ex: Guten Tag',
                    prefixIcon: Icon(Icons.language),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira uma palavra ou frase em alemão';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _backController,
                  decoration: const InputDecoration(
                    labelText: 'Tradução em Português',
                    hintText: 'Ex: Bom dia',
                    prefixIcon: Icon(Icons.translate),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira a tradução';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _saveCard,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSubmitting ? 'Salvando...' : 'Salvar Cartão'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 