import 'package:bankimoon/data/contributors.dart';
import 'package:flutter/material.dart';

class ContributorCard extends StatelessWidget {
  const ContributorCard({
    super.key,
    required this.contributor,
  });

  final Contributor contributor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Colors.white,
            child: SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 8,
                  ),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contributor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          contributor.ghUsername,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          contributor.url,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
