import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../providers/providers.dart';
import '../providers/cart_provider.dart';
import '../providers/db_provider.dart';
import '../../data/database/database.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    final db = ref.read(databaseProvider); // Доступ к нашей БД Drift

    return Scaffold(
      appBar: AppBar(
        title: const Text('AITU Sports Market', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () => context.push('/favorites'), // Переход в избранное
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () => context.push('/cart'), // Переход в корзину
          ),
        ],
      ),
      body: productsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
        data: (products) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55, // Сделали карточку чуть выше для кнопок
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(product.image, fit: BoxFit.contain),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('\$${product.price}', style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Логика Избранного (Drift)
                              StreamBuilder<bool>(
                                stream: db.isFavorite(product.id),
                                builder: (context, snapshot) {
                                  final isFav = snapshot.data ?? false;
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                    onPressed: () {
                                      if (isFav) {
                                        db.removeFavorite(product.id);
                                      } else {
                                        db.addFavorite(FavoritesCompanion(
                                          productId: drift.Value(product.id),
                                          title: drift.Value(product.title),
                                          price: drift.Value(product.price),
                                          image: drift.Value(product.image),
                                        ));
                                      }
                                    },
                                  );
                                },
                              ),
                              // Логика Корзины (Riverpod)
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                                onPressed: () {
                                  ref.read(cartProvider.notifier).addProduct(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Товар добавлен в корзину!'), duration: Duration(seconds: 1)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}