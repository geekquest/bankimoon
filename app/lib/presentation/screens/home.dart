import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/widgets/account_list_widget.dart';
import 'package:bankimoon/presentation/widgets/card.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BlocProvider.of<AccountsCubit>(context).getUserAccounts();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bankimoon",
          style: titleStyles,
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.ac_unit,
          color: Color.fromARGB(255, 15, 91, 254),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45.0,
              child: SearchBar(
                leading: const Icon(Icons.search),
                hintText: "Search",
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    BlocProvider.of<AccountsCubit>(context)
                        .searchAccount(value.toString());
                  } else {
                    BlocProvider.of<AccountsCubit>(context).getUserAccounts();
                  }
                },
              ),
              //width: 300.0,
            ),
          ),
        ),
      ),
      body: BlocBuilder<AccountsCubit, AccountsState>(
        builder: (context, state) {
          if (state is AccountsFetched) {
            if (state.accounts.isEmpty) {
              return SizedBox(
                height: size.height,
                width: size.width,
                child: const Center(
                  child: Text(
                    'No accounts saved',
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Your Accounts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  AccountListWidget(accounts: state.accounts, onDismissed: (index, direction){
                    if (direction == DismissDirection.startToEnd) {
                      BlocProvider.of<AccountsCubit>(context)
                          .deleteAccount(state.accounts[index].id!);
                    }
                  }),
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
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                        //placeholder for button
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: state.accounts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AccountCard(
                          accountId: state.accounts[index].id,
                          accountName: state.accounts[index].accountName,
                          accountNumber:
                              state.accounts[index].accountNumber.toString(),
                          bankName: state.accounts[index].bankName,
                          isFavourite: state.accounts[index].isFavourite,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          } else if (state is ErrorState) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                  child: Text(
                    state.message,
                  )),
            );
          }
          else {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 15, 91, 254),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}