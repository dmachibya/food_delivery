import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isButtonPressed = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700])),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text("Arusha Technical College".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                          textStyle:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ))),
                  Text(
                    '"Skills makes the difference"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle:
                            Theme.of(context).textTheme.headline3!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                )),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Create an Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle:
                            Theme.of(context).textTheme.headline3!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please write your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.white70,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Name',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please write your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white70,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Email',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please write a password";
                        }
                        return null;
                      },
                      obscureText: isPasswordVisible ? false : true,
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white70,
                            size: 22,
                          ),
                          suffixIconConstraints:
                              BoxConstraints(minWidth: 45, maxWidth: 46),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: 22,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Password',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: !isButtonPressed
                        ? () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isButtonPressed = true;
                              });

                              AuthHelper()
                                  .signUp(
                                      name: nameController.text,
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
                      height: 53,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      decoration: !isButtonPressed
                          ? BoxDecoration(
                              boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black12.withOpacity(.2),
                                      offset: Offset(2, 2))
                                ],
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              gradient: LinearGradient(colors: [
                                Colors.green.shade900,
                                Colors.green.shade700
                              ]))
                          : BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.4)),
                      child: Text('Register',
                          style: TextStyle(
                              color: !isButtonPressed
                                  ? Colors.white.withOpacity(.8)
                                  : Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Already have an account?',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go("/login");
                    },
                    child: Container(
                      height: 53,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60),
                        borderRadius: BorderRadius.circular(100)
                            .copyWith(bottomRight: Radius.circular(0)),
                      ),
                      child: Text('Login',
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
