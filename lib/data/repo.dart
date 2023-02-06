import 'package:bankimoon/data/database.dart';

class Repository {
  final DbManager connection;

  Repository({required this.connection});

  Future createPassword(String password) async {
    final data = await connection.createPassword(password);
    return data;
  }
}
