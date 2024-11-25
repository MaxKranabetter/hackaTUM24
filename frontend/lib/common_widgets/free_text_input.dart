import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';

class FreeTextInputBox extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  const FreeTextInputBox({
    required this.textEditingController,
    required this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 217, 217, 217), fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 217, 217, 217),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 217, 217, 217),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primaryColor, // Green border when focused
          ),
        ),
      ),
      maxLines: 2,
    );
  }
}
