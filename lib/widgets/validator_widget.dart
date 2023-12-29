class Validator {
  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um nome de usuário.';
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
