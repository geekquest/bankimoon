import 'package:bankimoon/data/Models/accounts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarRepo {
  IsarRepo._();
  static final IsarRepo _instance = IsarRepo._();
  static IsarRepo get instance => _instance;

  late Isar isarInstance;

  init () async {
    final dir = await getApplicationDocumentsDirectory();
    isarInstance = await Isar.open([AccountSchema], directory: dir.path);
  }


}