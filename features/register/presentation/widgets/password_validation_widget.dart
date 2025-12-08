// features/register/presentation/widgets/password_validation_widget.dart (NUEVO ARCHIVO)

import 'package:flutter/material.dart';

// Controlador para comunicar el estado de validación al formulario padre.
class PasswordValidationController extends ChangeNotifier {
  bool _isPasswordValid = false;

  bool get isPasswordValid => _isPasswordValid;

  void updateValidation(bool isValid) {
    if (_isPasswordValid != isValid) {
      _isPasswordValid = isValid;
      notifyListeners();
    }
  }
}

class PasswordValidationWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final PasswordValidationController validationController;

  const PasswordValidationWidget({
    super.key,
    required this.passwordController,
    required this.validationController,
  });

  @override
  State<PasswordValidationWidget> createState() => _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState extends State<PasswordValidationWidget> {
  // Banderas para cada una de las reglas de validación
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    // Escuchamos los cambios en el campo de texto de la contraseña
    widget.passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_validatePassword);
    super.dispose();
  }

  void _validatePassword() {
    final password = widget.passwordController.text;

    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });

    // Notificamos al controlador si todas las reglas se cumplen
    final allValid = _hasMinLength && _hasUppercase && _hasLowercase && _hasNumber && _hasSpecialChar;
    widget.validationController.updateValidation(allValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationRow('Al menos 8 caracteres', _hasMinLength),
        const SizedBox(height: 4),
        _buildValidationRow('Al menos una letra mayúscula (A-Z)', _hasUppercase),
        const SizedBox(height: 4),
        _buildValidationRow('Al menos una letra minúscula (a-z)', _hasLowercase),
        const SizedBox(height: 4),
        _buildValidationRow('Al menos un número (0-9)', _hasNumber),
        const SizedBox(height: 4),
        _buildValidationRow('Al menos un carácter especial (!@#\$...)', _hasSpecialChar),
      ],
    );
  }

  // Widget para construir cada fila de la lista de validación
  Widget _buildValidationRow(String text, bool isValid) {
    final color = isValid ? Colors.green : Colors.red;
    return Row(
      children: [
        Icon(isValid ? Icons.check_circle : Icons.cancel, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}