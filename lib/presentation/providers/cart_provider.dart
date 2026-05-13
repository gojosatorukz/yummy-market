import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product.dart';

// Класс, который управляет состоянием корзины (добавление и очистка)
class CartNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    return []; // Изначально корзина пуста
  }

  void addProduct(Product product) {
    state = [...state, product]; // Создаем новый список с добавленным товаром
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0, (sum, item) => sum + item.price);
  }
}

// Сам провайдер, к которому мы будем обращаться из интерфейса
final cartProvider = NotifierProvider<CartNotifier, List<Product>>(() {
  return CartNotifier();
});