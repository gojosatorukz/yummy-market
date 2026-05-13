import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database.dart';

// Провайдер самого подключения к БД
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  // Закрываем БД, когда приложение выключается
  ref.onDispose(() => db.close());
  return db;
});

// Провайдер, который транслирует список избранного на экраны
final favoritesStreamProvider = StreamProvider<List<Favorite>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllFavorites();
});