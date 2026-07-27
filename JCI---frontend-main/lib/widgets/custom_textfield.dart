import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.maxLength,
    this.maxLines,
    this.expands,
    this.inputType,
    this.labelText,
    this.initialValue,
    this.letterSpacing,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.obscureText,
    this.onTap,
    this.validator,
    this.prefixText,
    this.hintText,
    this.autoValidateMode,
    this.minLines,
    this.helperText,
    this.filled,
    this.fillColor,
    this.border,
    this.contentPadding,
    this.verticalPadding,
    this.onChanged,
    this.errorText,
    this.onEditingComplete,
  });

  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final TextInputType? inputType;
  final String? labelText;
  final String? initialValue;
  final double? letterSpacing;
  final double? verticalPadding;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool? readOnly;
  final bool? obscureText;
  final bool? filled;
  final Color? fillColor;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autoValidateMode;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 5.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        expands: expands ?? false,
        keyboardType: inputType,
        initialValue: initialValue,
        obscureText: obscureText ?? false,
        readOnly: readOnly ?? false,
        onTap: onTap,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        autovalidateMode: autoValidateMode,
        validator: validator,
        style: TextStyle(letterSpacing: letterSpacing),
        decoration: InputDecoration(
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
          border: border ??
              UnderlineInputBorder(
                borderSide: BorderSide.none,
                // borderRadius: BorderRadius.circular(10.0),
              ),
          enabledBorder: border ??
              UnderlineInputBorder(
                borderSide: BorderSide.none,
                // borderRadius: BorderRadius.circular(10.0),
              ),
          filled: true,
          fillColor: Colors.grey.shade200,
          labelText: labelText,
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          errorText: errorText,
          helperText: helperText ?? ' ',
        ),
      ),
    );
  }
}
