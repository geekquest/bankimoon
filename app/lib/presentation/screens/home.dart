import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/widgets/account_card.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/buttons.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountsCubit accountsCubit = BlocProvider.of<AccountsCubit>(context);
    final size = MediaQuery.of(context).size;
    BlocProvider.of<AccountsCubit>(context).useraccounts();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          SearchButton(
            accountsCubit: accountsCubit,
          ),
          // SettingsButton(),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          Strings.title,
          style: titleStyles,
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<AccountsCubit, AccountsState>(
        builder: (context, state) {
          if (state is AccountsFetched) {
            if (state.accounts.isEmpty) {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: Center(
                  child: Text(
                    Strings.noAcc,
                    style: const TextStyle(
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
                    child: Text(
                      Strings.yourAcc,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: state.accounts.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            BlocProvider.of<AccountsCubit>(context)
                                .deleteAccount(
                              state.accounts[index].id,
                            );
                          }
                        },
                        key: Key(state.accounts[index].id.toString()),
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
                                  'Are you sure you want to delete ${state.accounts[index].accountName} account?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
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
                            accountName: state.accounts[index].accountName,
                            accountNumber:
                                state.accounts[index].accountNumber.toString(),
                            bankName: state.accounts[index].bankName,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          } else if (state is AccountSearchResults) {
            if (state.accounts.isEmpty) {
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
                      children: [
                        const Text(
                          "Account Search Results",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (state.accounts.length == 1)
                          Text(
                            "${state.accounts.length} result",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        else
                          Text(
                            "${state.accounts.length} results",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
          } else {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple[800],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: const AddAccountButton(),
    );
  }
}
