mixin PasswordValidationMixin {

  bool isPasswordValid(String password) {
    RegExp regex = new RegExp(r"(\w+)");
    return regex.hasMatch(password);
  }
}