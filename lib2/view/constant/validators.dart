String? nameValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter your name";
  }
  if (value.length < 4) {
    return "Name is too short";
  }
  return null;
}

String? benchValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter a bench name";
  }
  if (value.length < 4) {
    return "Name is too short";
  }
  return null;
}


String? emailValidator(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value!.isEmpty) {
    return "Please enter a email";
  } else if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  }
  return null;
}

String? phoneValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter a phone number";
  }
  if (value.length != 10) {
    return "Phone number is invalid";
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter a password";
  } else if (value.length < 8) {
    return 'Minimum 8 characters';
  } else if (value.length > 16) {
    return 'Maximum 16 characters';
  }
  return null;
}

String? confirmPassword(String? value, String? value2) {
  if (value! != value2) {
    return "Passwords does not match";
  }
  return null;
}

String? countryValidator(String? value) {
  if (value!.isEmpty) {
    return "Mention your country";
  }
  return null;
}

String? fieldValidator(String? value) {
  if (value!.isEmpty) {
    return "необходимый";
  }
  return null;
}
