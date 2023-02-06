class Account {
  int id;
  String bankName;
  String accountName;
  int accountNumber;

  Account({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
  });

  Account fromJson(json) {
    return Account(
      id: json['id'],
      bankName: json['bankName'],
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
    };
  }
}
