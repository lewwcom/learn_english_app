import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_english_app/models/User.dart';
import 'package:learn_english_app/models/login_response.dart';
import 'package:learn_english_app/models/login_resquest.dart';
import 'package:learn_english_app/services/api_forgotpass.dart';
import 'package:learn_english_app/services/api_google_sign_in.dart';
import 'package:learn_english_app/services/api_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learn_english_app/services/api_username.dart';

class LoginPage extends StatefulWidget {
  static String? username;
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginRequest loginRequest = LoginRequest();
  APILogin api = APILogin();
  APIForgot forgotApi = APIForgot();

  @override
  void initState() {
    super.initState();
    // initName();
  }

  initName() async {
    User ava = await getUserName();
    LoginPage.username = ava.content;
    // ignore: avoid_print
    print(LoginPage.username.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "User Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                loginRequest.username = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text) {
                              setState(() {
                                loginRequest.password = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                minimumSize: const Size(double.infinity, 50)),
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.red,
                            ),
                            label: const Text('Log in with Google'),
                            onPressed: () async {
                              final user = await GoogleSignInApi.login();
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Cannot login with google')),
                                );
                              } else {
                                GoogleSignInAuthentication googleKey =
                                    await user.authentication;
                                LoginResponse value =
                                    await GoogleSignInApi.sendToBack(
                                        googleKey.accessToken);

                                if (value.success == true) {
                                  await initName();
                                  GoogleSignInApi.setGoogleSigin();
                                  context.push('/');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Invalid username or password.')),
                                  );
                                  GoogleSignInApi.logout();
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      print("test đăng nhập");
                                      LoginResponse value =
                                          await api.login(loginRequest);

                                      if (value.success == true) {
                                        await initName();
                                        context.push('/');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Invalid username or password.')),
                                        );
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.push('/signup');
                                },
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: const ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    print("test quên mật khẩu");
                                    context.push('/forgotpassword');
                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
