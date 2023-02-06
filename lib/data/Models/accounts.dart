class Account {
  int id;
  String bankName;
  String accountNumber;

  Account({
    required this.id,
    required this.bankName,
    required this.accountNumber,
  });

  Account fromJson(json) {
    return Account(
      id: json['id'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
    };
  }
}
