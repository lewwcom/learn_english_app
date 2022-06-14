import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//import 'package:learn_english_app/models/signup_resquest.dart';
import '../../models/signup_resquest.dart';

import 'package:learn_english_app/services/api_signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupRequest signupRequest = SignupRequest();
  APISignup api = APISignup();
  final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.21),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Username",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length >= 10) {
                                    return null;
                                  } else if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 10) {
                                    return 'Too short';
                                  } else {
                                    return 'Please give us your name';
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    signupRequest.username = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Phone",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Please give us your phone';
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    signupRequest.phone_number = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Password",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length > 5) {
                                    return null;
                                  } else if (value != null &&
                                      value.isNotEmpty &&
                                      value.length <= 5) {
                                    return 'Too short';
                                  } else {
                                    return 'Please give us your password';
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    signupRequest.password = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Confirmation Password",
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        value == signupRequest.password) {
                                      return null;
                                    } else if (value != null &&
                                        value.isNotEmpty &&
                                        // ignore: unrelated_type_equality_checks
                                        value != signupRequest) {
                                      return 'Incorrect';
                                    }
                                  },
                                  onChanged: (text) {
                                    setState(() {
                                      signupRequest.password_confirmation =
                                          text;
                                    });
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (!_formkey.currentState!
                                              .validate()) {
                                          } else {
                                            // ignore: avoid_print
                                            print("test đăng kí");
                                            //print(signupRequest.toJson());
                                            api
                                                .signup(signupRequest)
                                                .then((value) {
                                              //print("-----SIGNUP------");
                                              //print(value.toJson());
                                              if (value.success == true) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Your account has been registered.')),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Username or phone already in use')),
                                                );
                                              }
                                              // ignore: avoid_print
                                              print(value.content);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.push('/login');
                                    },
                                    child: const Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    style: const ButtonStyle(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
