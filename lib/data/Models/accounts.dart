import 'package:isar/isar.dart';

part 'accounts.g.dart';

@collection
class Account {
  Id? id = Isar.autoIncrement;
  String bankName;
  String accountName;
  String accountNumber;
  bool isFavourite;

  Account({
    this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.isFavourite,
  });

  static Account fromJson(json) {
    return Account(
      id: json['id'],
      bankName: json['bankName'],
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      isFavourite: (json['isFavourite'] == '1' || json['isFavourite'] == 1 || json['isFavourite'] == 'TRUE'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'isFavourite': isFavourite,
    };
  }
}
