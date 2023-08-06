import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:flutter/material.dart';
import '../../data/Models/accounts.dart';

class AccountSearchDelegate extends SearchDelegate<String> {
  final AccountsCubit accountsCubit;

  AccountSearchDelegate({required this.accountsCubit});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    return FutureBuilder<List<Account>>(
      future: accountsCubit.searchAccount(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for search results
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if there was an error during search
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Display the search results when available
          final List<Account> searchResults = snapshot.data ?? [];
          if (searchResults.isEmpty) {
            return Center(child: Text('Account not found'));
          } else {
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(searchResults[index].accountName),
                subtitle: Text(searchResults[index].bankName),
                onTap: () {
                  // Optionally, you can close the search delegate and use the selected account.
                  // close(context, searchResults[index].accountName);
                },
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    accountsCubit.searchAccount(query);
    super.showResults(context);
  }
}
