import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final EdgeInsets contentPadding;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? textController;


  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.obscureText = false,
    this.keyboardType, 
    this.textController
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusColor: Theme.of(context).inputDecorationTheme.focusColor,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Theme.of(context).iconTheme.color),
        contentPadding: contentPadding,
      ),
      keyboardType: keyboardType,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
