import 'dart:convert';

import '../model/response_model.dart';

class APIService {
  Future<dynamic> login(LoginRequestModel loginRequestModel) async {
    String url = "https://arabiclanguageapp.co.uk/admin/api/login";
    final response =
    await http.post(Uri.parse(url), body: loginRequestModel.toJson());

    if (response.statusCode == 201 || response.statusCode == 400) {
      print("res code" + response.statusCode.toString());
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      return ("Oops! signin failed!");
    }
  }

  Future<dynamic> signUp(SignUpRequestModel signUpRequestModel) async {
    String url = "https://arabiclanguageapp.co.uk/admin/api/register";
    final response =
    await http.post(Uri.parse(url), body: signUpRequestModel.toJson());

    if (response.statusCode == 200) {
      print("Status code = " + response.statusCode.toString());
      print(response.body.toString());
      return SignUpResponseModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      print("Registration failed");
      return (response.body.toString());
    } else {
      return ("Failed to load data");
    }
  }
}

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
  final String token;
  //final int otp;

  LoginResponseModel({required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["token"] != null ? json["token"] : "");
    // otp: json["otp"] != null ? json["otp"] : "");
  }
}

