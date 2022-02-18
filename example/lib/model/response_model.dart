import 'package:flutter/cupertino.dart';

class SignUpRequestModel {
  // String firstname;
  // String lastname;
  String email;
  String password;

  SignUpRequestModel(
      {
        // required this.firstname,
        // required this.lastname,
        required this.email,
        required this.password,
       });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      // "first_name": this.firstname,
      // "last_name": this.lastname,
      "email": this.email,
      "password": this.password,
    };
    return map;
  }
}

class SignUpResponseModel {
  var token;
  SignUpResponseModel({this.token});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
        token: json["token"] != null ? json["token"] : "");
  }
}