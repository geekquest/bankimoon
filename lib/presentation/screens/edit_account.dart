import 'package:bankimoon/data/Models/accounts.dart';
import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditAccountPage extends StatefulWidget {
  final int accountId;
  const EditAccountPage({super.key, required this.accountId});

  @override
  State<EditAccountPage> createState() => _EditAccountState(accountId);
}

class _EditAccountState extends State<EditAccountPage> {
  final int accountId;
  _EditAccountState(this.accountId);

  Account? account;
  
  final formkey = GlobalKey<FormState>();
  String institutionName = 'National Bank of Malawi';
  final TextEditingController accountName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();

    @override
  void initState() {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      BlocProvider.of<AccountsCubit>(context).stream.listen((state) {
        if (state is SingleAccountFetched) {
          setState(() {
            account = state.account;
            accountName.text = state.account.accountName;
            accountNumber.text = state.account.accountNumber;
            
          });
        }
      });

      BlocProvider.of<AccountsCubit>(context).findById(accountId);
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Account',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: TextFormField(
                        controller: accountName,
                        validator: (value) {
                          if (value == '') {
                            return 'Please Enter your Account Name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        // obscureText: true,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          hintText: "Type or paste account name",
                          labelText: "Account Name",
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: accountNumber,
                      validator: (value) {
                        if (value == '') {
                          return 'Please Enter your Account Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_balance,
                        ),
                        isDense: true,
                        hintText: "Type or paste account number",
                        labelText: "Account Number",
                        isCollapsed: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          // color: Color,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: institutionName,
                            hint: const Text('Institution Name'),
                            items: serviceProviders
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                institutionName = value.toString();
                                account!.bankName = institutionName;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        final form = formkey.currentState;
                        if (form != null && form.validate()) {
                          account!.accountName = accountName.text.trim();
                          account!.accountNumber = accountNumber.text.trim();
                          account!.bankName = institutionName;
                          BlocProvider.of<AccountsCubit>(context).updateAccount(account!);
                          context.go('/home');
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(14.5),
                        decoration: btnStyle,
                        child: BlocConsumer<AccountsCubit, AccountsState>(
                            listener: (context, state) {
                          if (state is AccountSubmitted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  state.msg,
                                ),
                              ),
                            );
                            Navigator.pushReplacementNamed(context, home);
                          }
                        }, builder: (context, state) {
                          if (state is SubmittingAccount) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return const Text(
                              "Update Account Detail",
                              textAlign: TextAlign.center,
                              style: textStyle,
                            );
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
