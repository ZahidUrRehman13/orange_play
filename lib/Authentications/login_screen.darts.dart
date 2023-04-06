import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:orange_play/constants_services/colors_class.dart';
import 'package:orange_play/menu_screens/home_screens.dart';
import 'package:orange_play/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';

import '../mix_screens/chats/user_chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _passwordKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();

  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPassword;
  bool setobsureText = false;
  bool _isLoading = false;
  var credential;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerEmail!.dispose();
    _controllerPassword!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: AllColors.mainColor,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Container(
                    height: _height*0.3,
                    width: _width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/advertisement.gif")
                      )
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text("Welcome",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff313131),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          )),
                      SizedBox(width: _width*0.01,),
                      Text("To",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff313131),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          )),
                      SizedBox(width: _width*0.01,),
                      Text("𝘦𝘈𝘥𝘷𝘦𝘳𝘵𝘪𝘴𝘦",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff313131),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,

                          ))
                    ],
                  ),
                  SizedBox(
                    height: _height * 0.1,
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _height * 0.02,
                                horizontal: _width * 0.04),
                            child: TextFormField(
                              key: _emailKey,
                              controller: _controllerEmail,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              validator: validateEmail,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                counterText: "",
                                filled: true,
                                fillColor: AllColors.mainColor,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      // width: 1,
                                      ),
                                ),
                                hintText: "email",
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: 'Arial',
                                  color: Color(0xff16003b),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _height * 0.02,
                                horizontal: _width * 0.04),
                            child: TextFormField(
                              key: _passwordKey,
                              controller: _controllerPassword,
                              focusNode: _passwordFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              validator: validatePassword,
                              obscureText: setobsureText,
                              obscuringCharacter: "*",
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                counterText: "",
                                filled: true,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (setobsureText == true) {
                                        setState(() {
                                          setobsureText = false;
                                        });
                                      } else {
                                        setState(() {
                                          setobsureText = true;
                                        });
                                      }
                                    },
                                    icon: setobsureText
                                        ? const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.grey,
                                          )
                                        : const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          )),
                                fillColor: AllColors.mainColor,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                hintText: "password",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Arial',
                                  color: Color(0xff16003b),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //               const ResetPasswordScreen()));
                          //     },
                          //     child: forgetPassword(_height)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  GestureDetector(
                    onTap: (){
                      handleLoginUser();
                    },
                    child: Padding(
                      padding:EdgeInsets.only(
                          top: _height * 0.04,
                          left: _width * 0.04,
                          right: _width * 0.04),
                      child: Container(
                        height: _height * 0.075,
                        width: _width ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: const LinearGradient(
                              begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                              end: Alignment(1.3960868120193481, 1.4281718730926514),
                              colors: [Color(0xff4a54be), Color(0xff48bc71)]),
                        ),
                        child: Center(
                          child: Text(
                            "Login OR Register",
                            style: TextStyle(
                                color: Colors.white, fontSize: _width * 0.04),
                          )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 0.03),
                    child: Visibility(
                      visible: _isLoading,
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.275,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "enter valid email";
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "enter valid email";
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return "enter valid password";

    RegExp pass_valid = RegExp(
        r"(?=.*[0-9])(?=.*[A-Za-z])(?=.*[~!?@#$%^&*_-])[A-Za-z0-9~!?@#$%^&*_-]{8,40}$");
    if (!pass_valid.hasMatch(value)) {
      return "enter valid password";
    } else {
      return null;
    }
  }

  Widget forgetPassword(double height) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.03,
                  right: height * 0.04,
                  left: height * 0.04),
              child: Text("Forget Password",
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff313131),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: height * 0.04, left: height * 0.04),
              child: SizedBox(
                width: width * 0.22,
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void handleLoginUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      loginOrRegister();
    } else {}
  }

  void loginOrRegister() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _controllerEmail!.text.trim().toString(),
        password: _controllerPassword!.text.trim().toString(),
      )
          .then((value) {
        if (value.user != null) {
          setState(() {
            _isLoading = false;
          });
          context
              .read<UserProvider>()
              .setUserEmail(value.user!.email.toString());
          navigate();
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        try {
           await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _controllerEmail!.text.trim().toString(),
            password: _controllerPassword!.text.trim().toString(),
          ).then((value) {
            if (value.user != null) {
              setState(() {
                _isLoading = false;
              });
              context
                  .read<UserProvider>()
                  .setUserEmail(value.user!.email.toString());
              navigate();
            }
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }


  void navigate() {
    Transitioner(
      context: context,
      child:  HomeScreen(),
      animation: AnimationType.slideLeft, // Optional value
      duration: const Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
  }
}
