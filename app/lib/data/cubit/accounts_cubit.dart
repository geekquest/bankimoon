import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/repo.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repository repository;
  AccountsCubit({required this.repository}) : super(AccountsInitial());

//fetch user accounts
  void useraccounts() {
    emit(FetchingAccounts());
    repository.getAccounts().then((value) {
      emit(
        AccountsFetched(accounts: value),
      );
    });
  }

  // add account
  void addAccount(institutionName, accountName, accountNumber) {
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

  // delete account
  void deleteAccount(int id) {
    repository.deleteAccount(id);

    repository.getAccounts().then((value) {
      emit(
        AccountsFetched(accounts: value),
      );
    });
  }

  // nuke all accounts from db
  void nukeAccounts() {
    emit(DeletingAccounts());
    repository.deleteAccounts().then((value) => {
          emit(
            AccountsDeleted(
              msg: value['msg'],
            ),
          )
        });
  }
}
