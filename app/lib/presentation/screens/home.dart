import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BlocProvider.of<AccountsCubit>(context).useraccounts();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bankimoon",
          style: titleStyles,
        ),
        centerTitle: true,
        leading: Icon(
          Icons.ac_unit,
          color: Colors.deepPurple[800],
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Your Accounts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text('') //placeholder for button
                        // TODO: IMPLEMENT CLEAR ALL
                        // BlocConsumer<AccountsCubit, AccountsState>(
                        //   listener: (context, state) {
                        //     if (state is AccountsDeleted) {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //           content: Text(
                        //             state.msg,
                        //           ),
                        //         ),
                        //       );
                        //       BlocProvider.of<AccountsCubit>(context)
                        //           .useraccounts();
                        //     }
                        //   },
                        //   builder: (context, state) {
                        //     if (state is DeletingAccounts) {
                        //       return Center(
                        //         child: CircularProgressIndicator(
                        //           color: Colors.deepPurple[800],
                        //         ),
                        //       );
                        //     } else {
                        //       return GestureDetector(
                        //         onTap: () {
                        //           // Navigator.of(context).
                        //           BlocProvider.of<AccountsCubit>(context)
                        //               .nukeAccounts();
                        //         },
                        //         child: Container(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 13,
                        //             vertical: 5,
                        //           ),
                        //           decoration: BoxDecoration(
                        //               color: Colors.red,
                        //               borderRadius: BorderRadius.circular(
                        //                 50.0,
                        //               )),
                        //           child: const Text(
                        //             'Clear All',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     }
                        //   },
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: state.accounts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              state.accounts[index].accountName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${state.accounts[index].accountNumber.toString()} - ${state.accounts[index].bankName}',
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                // copy data to clipboard
                                Clipboard.setData(
                                  ClipboardData(
                                    text: state.accounts[index].accountNumber
                                        .toString(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Copied to clipboard")));
                              },
                              child: const Icon(
                                Icons.copy,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, addAccount);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
