import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/db_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Подписываемся на обновления базы данных
    final favoritesAsync = ref.watch(favoritesStreamProvider);
    final db = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Ошибка: $e')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text('Нет избранных товаров', style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return ListTile(
                leading: Image.network(item.image, width: 50, height: 50),
                title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${item.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => db.removeFavorite(item.productId), // Удаление из БД
                ),
              );
            },
          );
        },
      ),
    );
  }
}