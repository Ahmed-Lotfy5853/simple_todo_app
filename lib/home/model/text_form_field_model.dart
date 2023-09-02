import 'package:flutter/cupertino.dart';

class TextFormFieldModel {
  TextEditingController controller;
  String title;
  Function() onTap;
  bool readOnly;
  IconData icon;

  TextFormFieldModel({
    required this.controller,
    required this.title,
    required this.onTap,
     this.readOnly =false,
    required this.icon,
  });
}
