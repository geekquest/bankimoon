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

// create a user password
  void createPassword(String password) {
    emit(CreatingPassword());
    repository.createPassword(password).then((value) {
      emit(
        PasswordCreated(
          msg: value['msg'],
        ),
      );
    });
  }

//fetch user accounts
  void useraccounts() {
    emit(FetchingAccounts());
    repository.getAccounts().then((value) {
      emit(
        AccountsFetched(accounts: value),
      );
    });
  }
}
