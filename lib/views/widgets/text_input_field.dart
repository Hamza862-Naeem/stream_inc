// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';

import 'package:stream_inc/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String LabelText;
  final bool isObsecure;
  final IconData icon;
  const TextInputField({
    Key? key,
    required this.controller,
    required this.LabelText,
     this.isObsecure= false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: LabelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
           fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: borderColor,)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: borderColor))

      ),
      obscureText: isObsecure,
    );
  }
}
