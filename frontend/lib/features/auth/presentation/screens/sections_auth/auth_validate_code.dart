import 'package:flutter/material.dart';
import 'package:frontend/core/theme/colors.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_input_code.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_stepper.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_text.dart';
import 'package:frontend/features/otp/repositories/otp_repository.dart';
import 'package:frontend/shared/widgets/error_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthValidateCode extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onValidate;

  const AuthValidateCode({
    super.key,
    required this.onBack,
    required this.onValidate,
  });

  @override
  State<AuthValidateCode> createState() => _AuthValidateCodeState();
}

class _AuthValidateCodeState extends State<AuthValidateCode> {
  final _otpService = OtpRepository();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  String _errorMessage = '';
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _changeErrorMessage(String? message) async {
    setState(() {
      _errorMessage = message!;
    });
  }

  Future<void> _handleValidate() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.get('phoneNumber');
    await prefs.setString('phoneNumber', phoneNumber.toString());
    try {
      final result = await _otpService.verifyOtp(
        phoneNumber: phoneNumber.toString(),
        code: _code,
      );

      if (result) {
        widget.onValidate();
      }
    } catch (e) {
      _changeErrorMessage(e.toString());
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthText(label: 'Validar numero', isTitle: true),
          const SizedBox(height: 30),
          const AuthStepper(step: 2),
          const SizedBox(height: 30),
          const AuthText(
            label: 'Por favor, introduzca el código recibido vía SMS.',
            isTitle: false,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return Row(
                children: [
                  AuthInputCode(controller: _controllers[index]),
                  if (index < 5) const SizedBox(width: 10),
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ErrorText(text: _errorMessage),
            ),
          ),
          const SizedBox(height: 60),
          AuthButton(
            title: 'Validar',
            foregroundColor: Colors.white,
            border: false,
            backgroundColor: AppColors.primary,
            onPressed: _handleValidate,
          ),
          const SizedBox(height: 10),
          AuthButton(
            title: 'Volver',
            foregroundColor: AppColors.primary,
            border: true,
            backgroundColor: Colors.white,
            onPressed: widget.onBack,
          ),
        ],
      ),
    );
  }
}
