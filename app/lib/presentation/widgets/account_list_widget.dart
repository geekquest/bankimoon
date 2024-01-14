import 'package:bankimoon/presentation/widgets/card.dart';
import 'package:flutter/material.dart';

class AccountListWidget extends StatelessWidget {
  final List accounts;

  final Function(int, DismissDirection) onDismissed;

  const AccountListWidget(
      {super.key, required this.accounts, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return Dismissible(
          onDismissed: (direction) {
            onDismissed(index, direction);
          },
          key: Key(accounts[index].id.toString()),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              return showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'Delete account',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  content: Text(
                      'Are you sure you want to delete ${accounts[index].accountName} account?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }

            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccountCard(
              accountId: accounts[index].id!,
              accountName: accounts[index].accountName,
              accountNumber: accounts[index].accountNumber.toString(),
              bankName: accounts[index].bankName,
              isFavourite: accounts[index].isFavourite,
            ),
          ),
        );
      },
    );
  }
}