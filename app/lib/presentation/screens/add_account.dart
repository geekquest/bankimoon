import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key? key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final formKey = GlobalKey<FormState>();
  String institutionName = 'National Bank of Malawi';
  final TextEditingController accountName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAccountNameField(),
                const SizedBox(height: 15),
                buildAccountNumberField(),
                const SizedBox(height: 15),
                buildInstitutionDropdown(),
                const SizedBox(height: 15),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        'Add Account',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  TextFormField buildAccountNameField() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: accountName,
      validator: (value) {
        if (value == '') {
          return 'Please Enter your Account Name';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white,
        ),
        hintText: "Type or paste account name",
        labelText: "Account Name",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
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
            color: Colors.white,
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
    );
  }

  TextFormField buildAccountNumberField() {
    return TextFormField(
      controller: accountNumber,
      validator: (value) {
        if (value == '') {
          return 'Please Enter your Account Number';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      enableSuggestions: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.account_balance,
          color: Colors.white,
        ),
        hintText: "Type or paste account number",
        labelText: "Account Number",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
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
            color: Colors.white,
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
    );
  }

  Container buildInstitutionDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(
          5.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: institutionName,
          hint: const Text(
            'Institution Name',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          dropdownColor:
              Colors.grey[900], // Set the background color of the dropdown menu
          icon: const Icon(
            // Set the color of the dropdown arrow icon
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          items: banks.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              institutionName = value.toString();
            });
          },
        ),
      ),
    );
  }

  GestureDetector buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        final form = formKey.currentState;
        if (form != null && form.validate()) {
          BlocProvider.of<AccountsCubit>(context).addAccount(
            institutionName,
            accountName.text.trim(),
            accountNumber.text.trim(),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: btnStyle,
        child: BlocConsumer<AccountsCubit, AccountsState>(
          listener: (context, state) {
            if (state is AccountSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.msg),
                ),
              );
              Navigator.pushReplacementNamed(context, home);
            }
          },
          builder: (context, state) {
            if (state is SubmittingAccount) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
