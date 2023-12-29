import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  FocusNode? focusNode;
  List<TextInputFormatter>? inputFormatters;
  int? maxLength;
  TextInputType? keyboardType;
  bool obscureText;
  String? hintText;
  Function(String)? onChanged;
  Function(String?)? onSaved;
  Function(String?)? onFieldSubmitted;
  TextEditingController? controller;
  bool autofocus;
  String? Function(String?)? validator;
  AutovalidateMode? autovalidateMode;
  TextDirection? textDirection;
  TextStyle? errorStyle;
  Widget? suffixIcon;
  Color? cursorColor;
  TextStyle? textStyle;
  TextStyle? hintStyle;
  String? labelText;
  TextStyle? labelStyle;
  bool? enabled;
  bool? enabledInteractiveSelection;
  double? width;
  double? height;

  CustomTextFormField({
    Key? key,
    this.inputFormatters,
    this.maxLength,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.controller,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textDirection,
    this.errorStyle,
    this.suffixIcon,
    this.cursorColor = Colors.black,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    this.hintStyle = const TextStyle(
      color: Colors.black54,
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 1.5,
    ),
    this.labelText,
    this.labelStyle,
    this.enabled,
    this.enabledInteractiveSelection = true,
    this.width = 360,
    this.height,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        enabled: enabled,
        key: key,
        maxLength: maxLength,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        onSaved: onSaved,
        autofocus: autofocus,
        autovalidateMode: autovalidateMode,
        textDirection: textDirection,
        style: textStyle,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: hintStyle,
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFD0D5DD).withOpacity(1.0),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFD0D5DD).withOpacity(1.0),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
