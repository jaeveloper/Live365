class Validations {
  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateAddress(String value) {
    if (value.isEmpty) return 'Address is required';
    final RegExp nameExp =
        new RegExp(r'^(?=.*[a-z]){4,}(?=.*[A-Z]){4,}(?=.*[0-9]){2,}.{20,}$');
    if (!nameExp.hasMatch(value)) return 'Invalid Address';
    return null;
  } //^[0-9]{10}$

  String validateNumber(String value) {
    if (value.isEmpty) return 'Enter Amount';
    final RegExp nameExp = new RegExp(r'^[0-9]{1,}$');
    if (!nameExp.hasMatch(value)) return 'Invalid Amount';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    return null;
  }
}
