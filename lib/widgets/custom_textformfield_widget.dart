import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  bool hasError;
  double? cursorHeight;
  Radius? cursorRadius;
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
    this.cursorHeight,
    this.cursorRadius,
    this.hasError = false,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC4CED7).withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: widget.hasError ? const Color(0xFFD32F2F) : Colors.transparent,
        ),
      ),
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
        child: TextFormField(
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          key: widget.key,
          maxLength: widget.maxLength,
          onFieldSubmitted: widget.onFieldSubmitted,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          autofocus: widget.autofocus,
          autovalidateMode: widget.autovalidateMode,
          textDirection: widget.textDirection,
          style: widget.textStyle,
          cursorWidth: 1.0,
          cursorColor: widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            labelText: widget.labelText,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
