import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

dynamic encrypter(String password) {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(8);
  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
  final encrypted = encrypter.encrypt(password, iv: iv);
  return encrypted;
}

/// Update Company table V1 to V2
void _addIsFavouriteToAccountsTableV2(Batch batch) {
  batch.execute('ALTER TABLE accounts ADD isFavourite boolean default FALSE;');
}

class DbManager {
  // ignore: unused_field
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "bankimoon.db"),
      version: 3,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY autoincrement, bankName TEXT, accountName TEXT, accountNumber INTEGER, isFavourite TEXT)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS password(id INTEGER PRIMARY KEY autoincrement, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _addIsFavouriteToAccountsTableV2(batch);
        }
        await batch.commit();
      },
    );
    return _database;
  }

  // create password
  Future createPassword(String password) async {
    await openDb();
    final newPassword = encrypter(password).toString();
    final prefs = await SharedPreferences.getInstance();
    await _database.insert(
      "password",
      {
        'password': newPassword,
      },
    );

    prefs.setBool("loggedIn", true);
    return {
      'msg': 'Password created',
    };
  }

  // FETCH ACCOUNTS

  Future<List<Map<String, dynamic>>> getAccountList() async {
    await openDb();
    final List<Map<String, dynamic>> accounts =
        await _database.query('accounts');

    return accounts;
  }

  // add accounts
  Future addAccount(
      String accountName, String accountNumber, String bankName) async {
    await openDb();
    // convert account number to integer
    final newAc = int.parse(accountNumber);
    await _database.insert("accounts", {
      'bankName': bankName,
      'accountName': accountName,
      'accountNumber': newAc,
    });

    return {
      'msg': 'Account Saved',
    };
  }

  // delete account
  Future deleteAccount(int id) async {
    await openDb();

    await _database.delete("accounts", where: 'id = ?', whereArgs: [id]);

    return {
      'msg': 'Account deleted',
    };
  }

  // delete all accounts
  Future deleteAccounts() async {
    await openDb();

    await _database.delete('accounts');
    return {
      'msg': 'All accounts deleted',
    };
  }

  Future searchAccount(String searchQuery) async {
    await openDb();

    String sql =
        "SELECT * FROM accounts WHERE accountName LIKE ? OR accountNumber LIKE ?";

    List<dynamic> params = [
      '%${searchQuery.trim()}%',
      '%${searchQuery.trim()}%'
    ];

    final results = await _database.rawQuery(sql, params);

    return results;
  }

  Future getFavourites() async {
    await openDb();

    String sql = "SELECT * FROM accounts WHERE isFavourite = 1";

    final results = await _database.rawQuery(sql, []);

    return results;
  }

  Future searchFavouriteAccounts(String searchQuery) async {
    await openDb();

    String sql =
        "SELECT * FROM accounts WHERE isFavourite = 1 AND (accountName LIKE ? OR accountNumber LIKE ?)";

    List<dynamic> params = [
      '%${searchQuery.trim()}%',
      '%${searchQuery.trim()}%'
    ];

    final results = await _database.rawQuery(sql, params);

    return results;
  }

  Future markAsFavourite(int accountId) async {
    await openDb();

    String sql = "UPDATE accounts SET isFavourite = 1 WHERE id = ?";

    List<dynamic> params = [accountId];

    return await _database.rawQuery(sql, params);
  }
}
