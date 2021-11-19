mixin PasswordValidationMixin {
  bool isPasswordValid(String password) {
    RegExp regex = RegExp(r"(\w+)");
    return regex.hasMatch(password);
  }
}
