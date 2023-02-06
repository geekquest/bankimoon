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

class DbManager {
  // ignore: unused_field
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "bankimoon.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY autoincrement, bankName TEXT, accountName TEXT, accountNumber INTEGER)",
      );
      await db.execute(
        "CREATE TABLE IF NOT EXISTS password(id INTEGER PRIMARY KEY autoincrement, password TEXT)",
      );
    });
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
    final response = await _database.insert("accounts", {
      'bankName': bankName,
      'accountName': accountName,
      'accountNumber': newAc,
    });

    print(response);

    return {
      'msg': 'Account Saved',
    };
  }
}
