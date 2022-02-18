import 'package:flutter/cupertino.dart';

class SignUpRequestModel {
  String firstname;
  String lastname;
  String email;
  String password;
  String password_confirmation;

  SignUpRequestModel(
      {required this.firstname,
        required this.lastname,
        required this.email,
        required this.password,
        required this.password_confirmation});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "first_name": this.firstname,
      "last_name": this.lastname,
      "email": this.email,
      "password": this.password,
      "password_confirmation": this.password_confirmation
    };
    return map;
  }
}

class SignUpResponseModel {
  var otp;
  String error;
  SignUpResponseModel({this.otp, this.error});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
        otp: json["otp"] != null ? json["otp"] : "",
        error: json["error"] != null ? json["error"] : "");
  }
}