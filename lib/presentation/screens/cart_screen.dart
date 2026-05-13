import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Читаем текущее состояние корзины
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Ваша корзина пуста', style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(item.image, width: 50, height: 50),
                        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('\$${item.price}'),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого: \$${cartNotifier.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : () async {
                          // 1. Формируем заказ
                          final order = {
                            'date': DateTime.now().toIso8601String(),
                            'total': cartNotifier.totalPrice,
                            'items': cartItems.map((e) => e.title).toList(),
                          };
                          
                          // 2. Отправляем в Firebase
                          await FirebaseFirestore.instance.collection('orders').add(order);
                          
                          // 3. Очищаем корзину и радуем пользователя
                          cartNotifier.clearCart();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Заказ успешно оформлен! 🎉')),
                            );
                          }
                        },
                        child: const Text('Оформить'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}