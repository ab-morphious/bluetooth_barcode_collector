import 'dart:convert';

import 'package:flutter/material.dart';

class LoginRequestModel {
  String email;
  String password;
  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {"email": this.email, "password": this.password};
    return map;
  }
}

class LoginResponseModel {
  final String? token;
  //final int otp;

  LoginResponseModel({this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["token"] != null ? json["token"] : "");
    // otp: json["otp"] != null ? json["otp"] : "");
  }
}