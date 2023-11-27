import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/widgets/card.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BlocProvider.of<AccountsCubit>(context).favouritedAccounts();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bankimoon",
          style: titleStyles,
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45.0,
              child: SearchBar(
                leading: const Icon(Icons.search),
                hintText: "Search in Favourites",
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    BlocProvider.of<AccountsCubit>(context)
                        .searchFavouriteAccounts(value.toString());
                  } else {
                    BlocProvider.of<AccountsCubit>(context)
                        .favouritedAccounts();
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
                    'No accounts found',
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
                      "Favourited Accounts",
                      style: TextStyle(
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
                                .deleteAccount(state.accounts[index].id);
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
                                    'Are you sure you want to delete ${state.accounts[index].accountName} account?'),
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
                            accountId: state.accounts[index].id,
                            accountName: state.accounts[index].accountName,
                            accountNumber:
                                state.accounts[index].accountNumber.toString(),
                            bankName: state.accounts[index].bankName,
                            isFavourite: state.accounts[index].isFavourite,
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
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Search Results",
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
          } else if (state is AccountFetchError) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                  child: Text(
                state.message,
              )),
            );
          } else {
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
    );
  }
}
