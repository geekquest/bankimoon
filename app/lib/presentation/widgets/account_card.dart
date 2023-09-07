import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankimoon/data/cubit/accounts_cubit.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.isFavourite,
  });

  final int accountId;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final bool isFavourite;

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
                BlocProvider.of<AccountsCubit>(context)
                  .markAsFavourite(accountId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added to favourites"),
                  ),
                );
              },
              child: Icon(
                Icons.favorite,
                color: isFavourite ? Colors.red[400] : Colors.deepPurple
              ),
            ),
            const SizedBox(
              width: 8,
            ),
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
