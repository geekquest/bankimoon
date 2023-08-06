import 'package:bankimoon/data/repo.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import '../Models/accounts.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repository repository;
  AccountsCubit({required this.repository}) : super(AccountsInitial());

  // Fetch user accounts
  Future<void> useraccounts() async {
    emit(FetchingAccounts());
    try {
      final List<Account> accounts = await repository.getAccounts();
      emit(AccountsFetched(accounts: accounts));
    } catch (e) {
      emit(AccountsError(message: 'Error fetching accounts: $e'));
    }
  }

  // Add account
  void addAccount(
      String institutionName, String accountName, String accountNumber) {
    emit(SubmittingAccount());
    repository
        .addAccount(institutionName, accountName, accountNumber)
        .then((value) {
      emit(
        AccountSubmitted(
          msg: value['msg'],
        ),
      );
    });
  }

  // Search account
  // Inside AccountsCubit class

  Future<List<Account>> searchAccount(String query) async {
    emit(FetchingAccounts()); // Show loading state if needed

    final results = await repository.searchAccount(query);

    final List<Account> accounts = results.map<Account>((e) {
      return Account(
        id: e.id,
        bankName: e.bankName,
        accountName: e.accountName,
        accountNumber: e.accountNumber,
      );
    }).toList();

    emit(AccountSearchResults(accounts: accounts));

    return accounts;
  }

  // Delete account
  void deleteAccount(int id) {
    repository.deleteAccount(id).then((_) {
      // After deleting, fetch the updated accounts list and emit the state
      useraccounts();
    });
  }

  // Nuke all accounts from db
  void nukeAccounts() {
    emit(DeletingAccounts());
    repository.deleteAccounts().then((value) {
      emit(
        AccountsDeleted(
          msg: value['msg'],
        ),
      );
    });
  }
}
