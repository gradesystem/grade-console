part of common;


typedef String Validator(String value);


class Validators {

  String uri_validator($) {
    return Uri.parse($)==null?"Not so well-formed yet...":null;
  }
}
