import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Этот файл сгенерируется автоматически
part 'database.g.dart';

// 1. Описываем таблицу для Избранного
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().customConstraint('UNIQUE')(); // ID товара из API
  TextColumn get title => text()();
  RealColumn get price => real()();
  TextColumn get image => text()();
}

// 2. Создаем саму базу данных и методы работы с ней
@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Добавить товар в избранное
  Future<int> addFavorite(FavoritesCompanion entry) {
    return into(favorites).insert(entry, mode: InsertMode.insertOrReplace);
  }

  // Удалить товар из избранного
  Future<int> removeFavorite(int prodId) {
    return (delete(favorites)..where((t) => t.productId.equals(prodId))).go();
  }

  // Следить за всеми избранными товарами (Stream обновляет UI автоматически)
  Stream<List<Favorite>> watchAllFavorites() => select(favorites).watch();

  // Проверить, в избранном ли конкретный товар
  Stream<bool> isFavorite(int prodId) {
    return (select(favorites)..where((t) => t.productId.equals(prodId)))
        .watch()
        .map((list) => list.isNotEmpty);
  }
} // <-- Вот эта скобка закрывает класс AppDatabase!

// 3. Настройка файла базы данных на телефоне
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yummy_market.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}