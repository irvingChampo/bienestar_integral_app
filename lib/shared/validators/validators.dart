// shared/validators/validators.dart (CÓDIGO COMPLETO Y FINAL)

class AppValidators {
  /// Validador para correos electrónicos.
  ///
  /// Verifica que el campo no esté vacío y que tenga un formato de email válido.
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu correo electrónico.';
    }
    // Expresión regular para validar la mayoría de los formatos de email.
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, ingresa un correo electrónico válido.';
    }
    return null;
  }

  /// Validador para contraseñas con reglas de seguridad específicas.
  ///
  /// Nota: Este es el validador simple para el formulario. La validación visual
  /// se maneja con un widget separado.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña.';
    }
    if (value.length < 8) {
      return 'La contraseña no cumple los requisitos mínimos.';
    }
    // Reglas adicionales para una doble capa de validación
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula.';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número.';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial.';
    }
    return null;
  }

  /// Validador para campos de texto como nombres o apellidos.
  ///
  /// Verifica que el campo no esté vacío, que no contenga solo números,
  /// que no contenga caracteres especiales y que tenga una longitud mínima.
  static String? nameValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu $fieldName.';
    }
    if (value.trim().length < 3) {
      return 'El $fieldName debe tener al menos 2 letras.';
    }
    if (RegExp(r'^[0-9\s]+$').hasMatch(value)) {
      return 'El $fieldName no puede contener solo números.';
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$£€¥]').hasMatch(value)) {
      return 'El $fieldName no debe contener caracteres especiales.';
    }
    return null;
  }

  /// Validador para números de teléfono.
  ///
  /// Verifica que no esté vacío, que solo contenga números y tenga una longitud exacta de 10 dígitos.
  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu número de teléfono.';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.replaceAll(' ', ''))) {
      return 'El teléfono solo debe contener números.';
    }
    if (value.length != 10) {
      return 'El teléfono debe tener 10 dígitos.';
    }
    return null;
  }
}