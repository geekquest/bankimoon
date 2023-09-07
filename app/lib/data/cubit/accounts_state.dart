part of 'accounts_cubit.dart';

@immutable
abstract class AccountsState {}

class AccountsInitial extends AccountsState {}

class CreatingPassword extends AccountsState {}

class PasswordCreated extends AccountsState {
  final String msg;

  PasswordCreated({required this.msg});
}

class FetchingAccounts extends AccountsState {}

class AccountsFetched extends AccountsState {
  final List accounts;

  AccountsFetched({required this.accounts});
}

class SubmittingAccount extends AccountsState {}

class AccountSubmitted extends AccountsState {
  final String msg;

  AccountSubmitted({required this.msg});
}

class DeletingAccount extends AccountsState {}

class AccountDeleted extends AccountsState {
  final String msg;

  AccountDeleted({required this.msg});
}

class DeletingAccounts extends AccountsState {}

class AccountsDeleted extends AccountsState {
  final String msg;

  AccountsDeleted({required this.msg});
}

class AccountSearchResults extends AccountsState {
  final List accounts;

  AccountSearchResults({required this.accounts});
}

class AccountFetchError extends AccountsState {
  final String message;

  AccountFetchError({ required this.message });
}