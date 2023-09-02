import 'package:flutter/material.dart';
import 'package:simple_todo_app/home/model/text_form_field_model.dart';

import '../widgets/custom_text_field.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.task,
    required this.time,
    required this.date,
  });

  final TextFormFieldModel task;
  final TextFormFieldModel time;
  final TextFormFieldModel date;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return Column(
          children: [
            CustomTextFormField(
                textController: task.controller,
                label: task.title,
                icon: task.icon,
                readOnl: task.readOnly,
                tapFunction: () => task.onTap()),
            CustomTextFormField(
                textController: time.controller,
                label: time.title,
                icon: time.icon,
                readOnl: time.readOnly,
                tapFunction: () => time.onTap()),
            CustomTextFormField(
                textController: date.controller,
                label: date.title,
                icon: date.icon,
                readOnl: date.readOnly,
                tapFunction: () => date.onTap()),
          ],
        );
      },
      onClosing: () {
        Navigator.of(context).pop();
      },
    );
  }
}
