import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../utils/auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isButtonPressed = false;

  bool isPasswordVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // bool isButtonPressed = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void click() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Text(
                "Audiobooks App",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                height: 470,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Hello",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Please Login to Your Account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "This should not be left blank";
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.red,
                              ),
                              labelText: "Email Address",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "This should not be left blank";
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.eyeSlash,
                                color: Colors.red,
                              ),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: click,
                              child: const Text(
                                "Forget Password",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: !isButtonPressed
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isButtonPressed = true;
                                  });

                                  AuthHelper()
                                      .signIn(
                                          email: emailController.text
                                              .replaceAll(" ", ""),
                                          password: passwordController.text)
                                      .then((value) {
                                    setState(() {
                                      isButtonPressed = false;
                                    });
                                    if (value == null) {
                                      GoRouter.of(context).go("/");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("${value.toString()}"),
                                      ));
                                    }
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      isButtonPressed = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "There was an error-  ${error.toString()}"),
                                    ));
                                  });
                                }
                              }
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          decoration: !isButtonPressed
                              ? const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF8A2387),
                                        Color(0xFFE94057),
                                        Color(0xFFF27121),
                                      ]))
                              : BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.4)),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go('/login/register');
                              },
                              child: const Text(
                                "Register Account",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
