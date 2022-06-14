import 'package:flutter/material.dart';
import 'package:learn_english_app/models/change_password_response.dart';
import 'package:learn_english_app/services/api_changepass.dart';
import '../../models/change_password_request.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ChangePasswordResquest changePasswordResquest = new ChangePasswordResquest();
  final GlobalKey<FormState> _formkey = GlobalKey();
  APIChangePass api = APIChangePass();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/changepassword.png'), fit: BoxFit.cover),
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
                'Change\nPassword',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28),
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
                                    return 'too short';
                                  } else {
                                    return 'please give us your password';
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    changePasswordResquest.password = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 30,
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
                                    hintText: "New Password",
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
                                    return 'too short';
                                  } else {
                                    return 'please give us your new password';
                                  }
                                },
                                onChanged: (text) {
                                  setState(() {
                                    changePasswordResquest.newPassword = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 30,
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
                                        value ==
                                            changePasswordResquest
                                                .newPassword) {
                                      return null;
                                    } else if (value != null &&
                                        value.isNotEmpty &&
                                        value !=
                                            changePasswordResquest
                                                .newPassword) {
                                      return 'incorrect';
                                    }
                                  },
                                  onChanged: (text) {
                                    setState(() {
                                      changePasswordResquest
                                          .passwordConfirmation = text;
                                    });
                                  }),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Change Password',
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
                                        onPressed: () async {
                                          if (!_formkey.currentState!
                                              .validate()) {
                                          } else {
                                            print("test change pass");
                                            ChangePasswordResponse value =
                                                await api.changePass(
                                                    changePasswordResquest);

                                            if (value.success == true) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Change password succefully!')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Change password failed!')),
                                              );
                                            }
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
