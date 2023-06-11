import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
                        //placeholder for button
                        // TODO: IMPLEMENT CLEAR ALL
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
                        child: Dismissible(
                          confirmDismiss: (direction) => showDialog<bool>(
                            context: context,
                            builder: (BuildContext ctx) => AlertDialog(
                              title: const Text('Alert'),
                              content: Text(
                                  'Are you sure you want to delete ${state.accounts[index].accountName} account?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<AccountsCubit>(context)
                                        .deleteAccount(
                                            state.accounts[index].id);

                                    Navigator.pop(ctx, true);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                          key: Key(state.accounts[index].id.toString()),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                state.accounts[index].accountName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${state.accounts[index].accountNumber.toString()} - ${state.accounts[index].bankName}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // copy data to clipboard
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: state
                                              .accounts[index].accountNumber
                                              .toString(),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Copied to clipboard"),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.copy,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Share.share(
                                        "${state.accounts[index].bankName} \nName: ${state.accounts[index].accountName} \nAccount Number: ${state.accounts[index].accountNumber} \n \nShared from Bankimoon App",
                                      );
                                    },
                                    child: const Icon(
                                      Icons.share,
                                      color: Colors.deepPurple,
                                    ),
                                  )
                                ],
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
