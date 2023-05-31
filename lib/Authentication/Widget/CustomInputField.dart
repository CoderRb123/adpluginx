import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hint;
  final String? Function(String? value)? validate;
  final int maxLines;
  final bool readOnly;
  final TextEditingController controller;

  const CustomInputField(
      {Key? key,
      required this.label,
      required this.hint,
      required this.validate,
      required this.maxLines,
      required this.controller,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 0.02.sw,
          ),
          child: ListTile(
            title: Text(
              label ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 0.05.sw,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            maxLines: maxLines ?? 1,
            controller: controller,
            readOnly: readOnly,
            validator: validate,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint ?? "",
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
            ),
          ),
        )
      ],
    );
  }
}
