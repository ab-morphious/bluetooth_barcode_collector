import 'dart:convert';

import '../model/request_model.dart';
import '../model/response_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  String BASE_URL = "https://kirchat.com/qr_scaner/";
  Future<dynamic> login(LoginRequestModel loginRequestModel) async {
    String url = "$BASE_URL"+ "auth/login";
    final response =
    await http.post(Uri.parse(url), body: loginRequestModel.toJson());

    if (response.statusCode == 201 || response.statusCode == 400 || response
        .statusCode == 200) {
      print("res code" + response.statusCode.toString());
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      return ("Oops! signin failed!");
    }
  }

  Future<dynamic> signUp(SignUpRequestModel signUpRequestModel) async {
    String url = "$BASE_URL" + "auth/signup";
    final response =
    await http.post(Uri.parse(url), body: signUpRequestModel.toJson());

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
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


