import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final class LocalStorage {
  static const _favoritesBoxKey = 'favorites';

  LocalStorage._internal();

  static final _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  Future<void> initialize() async {
    final databasePath = await getApplicationDocumentsDirectory();
    Hive.init(databasePath.path);
    await Hive.openBox<String>(_favoritesBoxKey);
  }

  Box<String> get favoritesBox => Hive.box<String>(_favoritesBoxKey);
}
