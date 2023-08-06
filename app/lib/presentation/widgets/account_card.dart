import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key? key,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  }) : super(key: key);

  final String accountName;
  final String accountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            accountName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            '$accountNumber\n$bankName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          trailing: PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'copy',
                child: ListTile(
                  leading: Icon(
                    Icons.copy,
                    color: Colors.deepPurple,
                  ),
                  title: Text('Copy'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Colors.deepPurple,
                  ),
                  title: Text('Share'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'copy') {
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
              } else if (value == 'share') {
                Share.share(
                  "$bankName \nName: $accountName \nAccount Number: $accountNumber \n \nShared from Bankimoon App",
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
