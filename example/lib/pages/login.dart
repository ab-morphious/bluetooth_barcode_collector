import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_elves_example/main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/route_manager.dart';

import '../api/api_service.dart';
import '../model/request_model.dart';
import '../model/response_model.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late LoginRequestModel logInRequestModel;
  @override
  void initState() {
    // TODO: implement initState
    logInRequestModel = LoginRequestModel(
      email: '',
      password: '',
    );
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF1A4DAD),
        body: DelayedDisplay(
          delay: Duration(milliseconds: 1000),
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.07, top: height * 0.02, right: width * 0.07),
            child: SingleChildScrollView(
              child: (Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Text(
                          'Hello there!',
                          style: TextStyle(fontSize: 34, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Please Login to Continue',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 90),
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontFamily: 'AlegreyaSans',
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                height: height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    )),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 15),
                                        child: Icon(
                                          Icons.email,
                                          color: Colors.white54,
                                        )),
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          logInRequestModel.email = value;
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade200),
                                            border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontFamily: 'AlegreyaSans',
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                height: height * 0.09,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    )),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 15),
                                        child: Icon(Icons.password_outlined,
                                            color: Colors.white54)),
                                    Expanded(
                                      child: TextField(
                                        obscureText: true,
                                        onChanged: (value) {
                                          logInRequestModel.password = value;
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            hintText: 'Password',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 1800),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              APIService apiService = new APIService();
                              await apiService.login(logInRequestModel).then(
                                      (value) => Get.to(MyApp(), transition: Transition.rightToLeft));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 35, top: 60),
                              width: width,
                              height: height * 0.09,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                              )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0, bottom: 40),
                            child: InkWell(
                              onTap: () {
                                Get.to(SignIn(),
                                    transition: Transition.noTransition);
                              },
                              child: Text(
                                'Forgot password ? ',
                                style: TextStyle(
                                    fontFamily: 'AlegreyaSans',
                                    fontSize: 16,
                                    color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
