import 'package:flutter/material.dart';
import 'package:frontend/core/theme/colors.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.isPassword,
    this.controller
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton( 
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
