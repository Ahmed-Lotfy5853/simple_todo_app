import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.icon,
      required this.textController,
      this.readOnl = false,
      required this.tapFunction});

  final String label;
  final IconData icon;
  final TextEditingController textController;
  final bool readOnl;

  final Function()? tapFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      readOnly: readOnl,
      onTap: () => tapFunction,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
