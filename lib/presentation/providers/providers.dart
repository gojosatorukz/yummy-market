import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/api_service.dart';
import '../../data/models/product.dart';

// 1. Провайдер для нашего API сервиса (чтобы не создавать его каждый раз заново)
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService.create();
});

// 2. FutureProvider, который асинхронно скачивает список товаров
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.getProducts();

  if (response.isSuccessful) {
    // API возвращает список, преобразуем его в наши Dart-объекты
    final List<dynamic> data = response.body;
    return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Не удалось загрузить товары');
  }
});