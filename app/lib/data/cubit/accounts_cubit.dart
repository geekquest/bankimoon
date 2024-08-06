import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/isar_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  IsarRepo repository = IsarRepo.instance;
  List<Account> accounts = [];

  AccountsCubit() : super(AccountsInitial());

  //fetch user accounts
  void getUserAccounts() {
    emit(FetchingAccounts());
    repository.getAccounts().then((value) {
      accounts = value;
      emit(
        AccountsFetched(accounts: value),
      );
    }).catchError((err) {
      emit(ErrorState(message: err.toString()));
    });
  }

  // Fetch favourite accounts from the store
  void favouriteAccounts() {
    emit(FetchingAccounts());
    repository.getFavourites().then((value) {
      accounts = value;
      emit(
        AccountsFetched(accounts: value),
      );
    }).catchError((err) {
      emit(ErrorState(message: err.toString()));
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
          msg: 'Account saved',
        ),
      );
    }).catchError((error) {
      emit(ErrorState(message: 'Got error $error'));
    });
  }

  // Search account
  void searchAccount(String query) {
    repository.searchAccount(query).then((value) {
      emit(AccountSearchResults(accounts: value));
    }).catchError((err) {
      emit(ErrorState(message: err.toString()));
    });
  }

  void searchFavouriteAccounts(String query) {
    repository.searchFavouriteAccounts(query).then((value) {
      emit(AccountSearchResults(accounts: value));
    }).catchError((err) {
      emit(ErrorState(message: err.toString()));
    });
  }

  Future<void> markAsFavourite(int accountId) async {
    await repository.markAsFavourite(accountId).catchError((err) {
      emit(ErrorState(message: err.toString()));
    }).whenComplete(() => getUserAccounts());
  }

  Future<void> toggleFavourite(int accountId) async {
    await repository.toggleFavourite(accountId).catchError((err) {
      emit(ErrorState(message: err.toString()));
    }).whenComplete(() => getUserAccounts());
  }

  // delete account
  Future<void> deleteAccount(int id) async {
    await repository.deleteAccount(id).catchError((err) {
      emit(ErrorState(message: err.toString()));
    }).whenComplete(() => getUserAccounts());
  }

  // nuke all accounts from db
  void nukeAccounts() {
    emit(DeletingAccounts());
    repository.deleteAccounts().then((value) => {
          emit(
            AccountsDeleted(
              msg: 'Accounts deleted',
            ),
          )
        }).catchError((err) {
      emit(ErrorState(message: err.toString()));
    });
  }

  // Migrate data from the SQLite to Isar
  Future migrateData() async {
    await repository.migrateData();
  }
}
