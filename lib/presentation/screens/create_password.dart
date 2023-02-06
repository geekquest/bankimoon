import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  void checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool("loggedIn");
    if (isLogged != null && isLogged == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, home);
    }
  }

  @override
  void initState() {
    checkIfLoggedIn();

    super.initState();
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController password = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: size.height,
            width: size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Bankimoon",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: btnColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value == '') {
                              return 'Please create your password';
                            }

                            if (value!.split('').length < 6) {
                              return 'Password must have at least 6 characters';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          // obscureText: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            hintText: "Create your password",
                            labelText: "Password",
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
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            final form = formkey.currentState;
                            if (form != null && form.validate()) {
                              BlocProvider.of<AccountsCubit>(context)
                                  .createPassword(password.text.trim());
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(14.5),
                            decoration: btnStyle,
                            child: BlocConsumer<AccountsCubit, AccountsState>(
                                listener: (context, state) {
                              if (state is PasswordCreated) {
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
                              if (state is CreatingPassword) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return const Text(
                                  "Create",
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
        ),
      ),
    );
  }
}
