import 'package:flutter/material.dart';

ScaffoldFeatureController toast(BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
      ),
    ),
  );
}
