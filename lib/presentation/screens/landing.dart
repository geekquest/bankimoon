import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/widgets/account_list_widget.dart';
import 'package:bankimoon/presentation/widgets/search_results_widget.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final accountsCubit = BlocProvider.of<AccountsCubit>(context);

      accountsCubit.stream.listen((state) {
        if (state is ErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            ),
          ),
        ),
      ),
      body: BlocBuilder<AccountsCubit, AccountsState>(
        builder: (context, state) {
          List<Account> accounts = [];

          if (state is AccountsFetched) {
            accounts = state.accounts;
          } else if (state is AccountSearchResults) {
            return SearchResultsWidget(accounts: state.accounts);
          } else if (state is FetchingAccounts || state is DeletingAccount) {
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

          return AccountListWidget(
            accounts: BlocProvider.of<AccountsCubit>(context).accounts,
            onDismissed: (index) {
              BlocProvider.of<AccountsCubit>(context)
                  .deleteAccount(accounts[index].id!);
            },
          );
        },
      ),
    );
    // return
  }
}
