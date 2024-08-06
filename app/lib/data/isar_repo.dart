import 'dart:developer';

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
    try {
      final dir = await getApplicationDocumentsDirectory();
      isarInstance = await Isar.open([AccountSchema], directory: dir.path);
    } catch (e) {
      log('Error initializing Isar: $e');
    }
  }

  Future<List<Account>> getAccounts() async {
    try {
      final data = await isarInstance.accounts.where().findAll();
      return data;
    } catch (e) {
      log('Error getting accounts: $e');
      throw Exception('Error getting accounts');
    }
  }

  Future<int> addAccount(
      String institutionName, String accountName, String accountNumber) async {
    try {
      return await isarInstance.writeTxn(() async {
        return await isarInstance.accounts.put(Account(
          bankName: institutionName,
          accountName: accountName,
          accountNumber: accountNumber,
          isFavourite: false,
        ));
      });
    } catch (e) {
      log('Error adding account: $e');
      throw Exception('Error adding account');
    }
  }

  Future updateAccount(Account account) async {
    try {
      await isarInstance
          .writeTxn(() async => await isarInstance.accounts.put(account));
    } catch (e) {
      log('Error updating account: $e');
      throw Exception('Error updating account');
    }
  }

  Future deleteAccount(int id) async {
    try {
      await isarInstance
          .writeTxn(() async => await isarInstance.accounts.delete(id));
    } catch (e) {
      log('Error deleting account: $e');
      throw Exception('Error deleting account');
    }
  }

  Future deleteAccounts() async {
    try {
      await isarInstance.writeTxn(() async {
        await isarInstance.accounts.deleteAll([]);
      });
    } catch (e) {
      log('Error deleting accounts: $e');
      throw Exception('Error deleting accounts');
    }
  }

  Future<List<Account>> getFavourites() async {
    try {
      final data = await isarInstance.accounts
          .where()
          .filter()
          .isFavouriteEqualTo(true)
          .findAll();
      return data;
    } catch (e) {
      log('Error getting favourites: $e');
      throw Exception('Error getting favourites');
    }
  }

  Future markAsFavourite(int accountId) async {
    try {
      await isarInstance.writeTxn(() async {
        final account = await isarInstance.accounts.get(accountId);
        account!.isFavourite = true;
        await isarInstance.accounts.put(account);
      });
    } catch (e) {
      log('Error marking as favourite: $e');
      throw Exception('Error marking as favourite');
    }
  }

  Future<Account?> findById(int accountId) async {
    try {
      final account = await isarInstance.accounts.get(accountId);
      return account;
    } catch (e) {
      log('Error fetching account: $e');
      throw Exception('Error fetching account');
    }
  }

  Future toggleFavourite(int accountId) async {
    try {
      await isarInstance.writeTxn(() async {
        final account = await isarInstance.accounts.get(accountId);
        account!.isFavourite = !account.isFavourite;
        await isarInstance.accounts.put(account);
      });
    } catch (e) {
      log('Error toggling favourite status: $e');
      throw Exception('Error toggling as favourite');
    }
  }

  Future removeAsFavourite(int accountId) async {
    try {
      await isarInstance.writeTxn(() async {
        final account = await isarInstance.accounts.get(accountId);
        account!.isFavourite = false;
        await isarInstance.accounts.put(account);
      });
    } catch (e) {
      log('Error removing as favourite: $e');
      throw Exception('Error removing as favourite');
    }
  }

  Future<List<Account>> searchAccount(String query) async {
    try {
      final data = await isarInstance.accounts
          .where()
          .filter()
          .accountNameContains(query, caseSensitive: false)
          .findAll();
      return data;
    } catch (e) {
      log('Error searching account: $e');
      throw Exception('Error searching for account');
    }
  }

  Future<List<Account>> searchFavouriteAccounts(String query) async {
    try {
      final data = await isarInstance.accounts
          .where()
          .filter()
          .accountNameContains(query, caseSensitive: false)
          .and()
          .isFavouriteEqualTo(true)
          .findAll();
      return data;
    } catch (e) {
      log('Error searching favourite accounts: $e');
      throw Exception('Error searching favourite accounts');
    }
  }

  // Migrate data from SQLite to Isar
  Future migrateData() async {
    try {
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

        isarInstance.writeTxn(() => isarInstance.accounts.putAll(accountList));

        await db.deleteAccounts();
      }
    } catch (e) {
      log('Error migrating data: $e');
    }
  }
}
