import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/database.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarRepo {
  IsarRepo._();

  static final IsarRepo _instance = IsarRepo._();

  static IsarRepo get instance => _instance;

  late Isar isarInstance;

  init() async {
    final dir = await getApplicationDocumentsDirectory();
    isarInstance = await Isar.open([AccountSchema], directory: dir.path);
  }

  Future<List<Account>> getAccounts() async {
    final data = await isarInstance.accounts.where().findAll();
    return data;
  }

  Future addAccount(
      String institutionName, String accountName, String accountNumber) async {
    return await isarInstance.writeTxn(() async {
      var data = await isarInstance.accounts.put(Account(
        bankName: institutionName,
        accountName: accountName,
        accountNumber: int.parse(accountNumber),
        isFavourite: false,
      ));
      return data;
    });
  }

  deleteAccount(int id) async {
    await isarInstance
        .writeTxn(() async => await isarInstance.accounts.delete(id));
  }

  deleteAccounts() async {
    await isarInstance
        .writeTxn(() async => await isarInstance.accounts.deleteAll([]));
  }

  Future<List<Account>> getFavourites() async {
    final data = await isarInstance.accounts
        .where()
        .filter()
        .isFavouriteEqualTo(true)
        .findAll();
    return data;
  }

  markAsFavourite(int accountId) async {
    await isarInstance.writeTxn(() async {
      final account = await isarInstance.accounts.get(accountId);
      account!.isFavourite = true;
      await isarInstance.accounts.put(account);
    });
  }

  removeAsFavourite(int accountId) async {
    await isarInstance.writeTxn(() async {
      final account = await isarInstance.accounts.get(accountId);
      account!.isFavourite = false;
      await isarInstance.accounts.put(account);
    });
  }

  Future<List<Account>> searchAccount(String query) async {
    final data = await isarInstance.accounts
        .where()
        .filter()
        .accountNameContains(query)
        .findAll();
    return data;
  }

  searchFavouriteAccounts(String query) async {
    final data = await isarInstance.accounts
        .where()
        .filter()
        .accountNameContains(query)
        .and()
        .isFavouriteEqualTo(true)
        .findAll();
    return data;
  }

  // Migrate data from SQLite to Isar
  Future migrateData() async {
    final isarData = await isarInstance.accounts.where().findAll();
    final sqliteData = await DbManager().getAccountList();
    if (isarData.isEmpty && sqliteData.isNotEmpty) {
      final db = DbManager();
      final data = await db.getAccountList();
      // account list from the accounts map list above
      List<Account> accountList = [];

      for (var account in data) {
        accountList.add(Account.fromJson(account));
      }

      await isarInstance.writeTxn(() => isarInstance.accounts.putAll(accountList));

      await db.deleteAccounts();
    }
  }
}
