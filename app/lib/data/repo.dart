import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/database.dart';

class Repository {
  final DbManager connection;

  Repository({required this.connection});

  Future getAccounts() async {
    final data = await connection.getAccountList();
    return data
        .map(
          (e) => Account(
            id: e['id'],
            bankName: e['bankName'],
            accountName: e['accountName'],
            accountNumber: e['accountNumber'],
          ),
        )
        .toList();
  }

  Future addAccount(
      String institutionName, String accountName, String accountNumber) async {
    final data = await connection.addAccount(
        accountName, accountNumber, institutionName);
    return data;
  }

  Future<void> deleteAccount(int id) async {
    await connection.deleteAccount(id);
  }

  Future deleteAccounts() async {
    final data = await connection.deleteAccounts();
    return data;
  }

  Future<List<Account>> searchAccount(String query) async {
    final data = await connection.searchAccount(query);

    List<Account> accounts = data
        .map((e) => Account(
              id: e['id'],
              bankName: e['bankName'],
              accountName: e['accountName'],
              accountNumber: e['accountNumber'],
            ))
        .toList();

    return accounts;
  }
}
