import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  final String accountName;
  final String accountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          accountName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$accountNumber - $bankName',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // copy data to clipboard
                Clipboard.setData(
                  ClipboardData(
                    text: accountNumber,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Copied to clipboard"),
                  ),
                );
              },
              child: const Icon(
                Icons.copy,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () {
                Share.share(
                  "$bankName \nName: $accountName \nAccount Number: $accountNumber \n \nShared from Bankimoon App",
                );
              },
              child: const Icon(
                Icons.share,
                color: Colors.deepPurple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
