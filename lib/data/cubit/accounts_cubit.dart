import 'package:bankimoon/data/repo.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final Repository repository;
  AccountsCubit({required this.repository}) : super(AccountsInitial());

  void createPassword(String password) {
    emit(CreatingPassword());
    repository.createPassword(password).then((value) {
      print(value);
      emit(
        PasswordCreated(
          msg: value['msg'],
        ),
      );
    });
  }
}
