class Validator {
  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o nome de usuário Sankhya';
    } else {
      return null;
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe uma senha.';
    } else {
      return null;
    }
  }
}
