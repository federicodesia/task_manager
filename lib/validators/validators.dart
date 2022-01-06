bool isValidName(String value) => validateName(value) == null;
String? validateName(String value) {
  if(value.isEmpty) return "Please enter your name";
  if(value.length > 128) return "Maximum 128 characters";
  return null;
}

bool isValidEmail(String value) => validateEmail(value) == null;
String? validateEmail(String value) {
  if(value.isEmpty) return "Please enter your email";

  bool isValid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
  if(!isValid) return "Please enter a valid email";
  return null;
}

bool isValidPassword(String value) => validatePassword(value) == null;
String? validatePassword(String value) {
  if(value.isEmpty) return "Please enter your password";
  if(value.length < 8) return "Must contain at least 8 characters";
  if(value.length > 128) return "Maximum 128 characters";

  if(!RegExp(r'[0-9]').hasMatch(value)) return "Must contain at least one number";
  if(!RegExp(r'[a-z]').hasMatch(value)) return "Must contain at least one lowercase letter";
  if(!RegExp(r'[A-Z]').hasMatch(value)) return "Must contain at least one uppercase letter";
  return null;
}