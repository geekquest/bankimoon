import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:flutter/material.dart';
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[800],
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
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile();
                },
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
