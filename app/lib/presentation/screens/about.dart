import 'package:flutter/material.dart';
import 'package:bankimoon/presentation/widgets/contributor_card.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:bankimoon/data/contributors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _contributorList() {
    return Column(
        children:
            contributors.map((c) => ContributorCard(contributor: c)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Bankimoon",
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
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Text(bankimoonDescription),
              Text("Source Code:"),
              Text("https://github.com/geekquest/bankimoon",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.blue,
                  )),
              Text("Contributors:"),
            ]),
          ),
          _contributorList(),
        ]))));
  }
}
