

import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpRequestModel signUpRequestModel;
  @override
  void initState() {
    // TODO: implement initState
    signUpRequestModel = SignUpRequestModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              'assets/images/back_icon.png',
                              width: width * 0.1,
                            )),
                        alignment: Alignment.topLeft,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Hello there!',
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Welcome to Arabic',
                          style: TextStyle(
                            fontSize: 34,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Learn Arabic in a simple way',
                        style: TextStyle(
                            fontFamily: 'AlegreyaSans',
                            fontSize: 14,
                            color: grey),
                      ),
                    ],
                  ),
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
                                fontFamily: 'AlegreyaSans', fontSize: 14),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.09,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: grey,
                                )),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Image.asset(
                                      'assets/images/email_icon.png'),
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      signUpRequestModel.email = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: TextStyle(color: grey),
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
                  DelayedDisplay(
                    delay: Duration(milliseconds: 1800),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              APIService apiService = APIService();
                              if (!signUpRequestModel.email.isBlank &&
                                  signUpRequestModel.email != null) {
                                apiService
                                    .isEmailAvailable(signUpRequestModel.email)
                                    .then((value) {
                                  if (value != "error") {
                                    Get.to(SignUpForm2(signUpRequestModel),
                                        transition: Transition.noTransition);
                                  }else{
                                    showSnackBar("Email is already in use.", context, Colors.red);
                                  }
                                });
                              } else {
                                showSnackBar("Email can not be empty!", context,
                                    Colors.red);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 35, top: 60),
                              width: width,
                              height: height * 0.09,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Colors.black),
                              child: Center(
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 40),
                            child: InkWell(
                              onTap: () {
                                Get.to(SignIn(),
                                    transition: Transition.noTransition);
                              },
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                    fontFamily: 'AlegreyaSans',
                                    fontSize: 16,
                                    color: green),
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