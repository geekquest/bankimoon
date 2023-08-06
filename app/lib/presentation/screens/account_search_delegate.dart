import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/widgets/account_card.dart';
import 'package:flutter/material.dart';
import '../../data/Models/accounts.dart';

class AccountSearchDelegate extends SearchDelegate<String> {
  final AccountsCubit accountsCubit;

  AccountSearchDelegate({required this.accountsCubit});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final Future<List<Account>> searchResultsFuture =
        accountsCubit.searchAccount(query);

    return Container(
      color: Colors.black,
      child: FutureBuilder<List<Account>>(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple[800],
              ),
            );
          } else if (snapshot.hasError) {
            // Show error message if there was an error during search
            //TODO: Needs an illustration
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the search results when available
            final List<Account> searchResults = snapshot.data ?? [];
            if (searchResults.isEmpty) {
              return const Center(
                child: Text(
                  'Account not found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final account = searchResults[index];
                  return AccountCard(
                    accountName: account.accountName,
                    accountNumber: account.accountNumber.toString(),
                    bankName: account.bankName,
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    // We already called searchAccount in buildResults, no need to call it again.
    super.showResults(context);
  }
}
