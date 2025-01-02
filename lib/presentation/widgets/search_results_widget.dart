
import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/presentation/widgets/card.dart';
import 'package:flutter/material.dart';

class SearchResultsWidget extends StatefulWidget {

  final List<Account> accounts;

  const SearchResultsWidget({super.key, required this.accounts});

  @override
  State<SearchResultsWidget> createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {

  late List<Account> accounts;

  @override
  initState() {
    super.initState();
    accounts = widget.accounts;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (accounts.isEmpty) {
      return SizedBox(
        height: size.height,
        width: size.width,
        child: const Center(
          child: Text(
            'Account not found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Account Search Results",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${accounts.length} result${accounts.length == 1 ? "" : "s"}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AccountCard(
                  accountId: accounts[index].id!,
                  accountName: accounts[index].accountName,
                  accountNumber:
                  accounts[index].accountNumber.toString(),
                  bankName: accounts[index].bankName,
                  isFavourite: accounts[index].isFavourite,
                ),
              );
            },
          ),
        ],
      );
    }
  }
}
