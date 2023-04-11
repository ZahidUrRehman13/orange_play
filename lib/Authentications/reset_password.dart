import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange_play/Authentications/login_screen.darts.dart';
import 'package:transitioner/transitioner.dart';

import '../constants_services/colors_class.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();

  TextEditingController? _controllerEmail;

  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerEmail!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery
        .of(context)
        .size
        .height;
    var _width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            color: AllColors.mainColor,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: _height * 0.02,
                  ),
                  Container(
                    height: _height * 0.2,
                    width: _width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                            AssetImage("assets/images/advertisement.gif"))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Reset Password",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff313131),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          )),
                      SizedBox(
                        width: _width * 0.01,
                      ),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.1,
                  ),
                  GestureDetector(
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        reset(_controllerEmail!.text.trim().toString());
                      } else {}

                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: _height * 0.01,
                          left: _width * 0.04,
                          right: _width * 0.04),
                      child: Container(
                        height: _height * 0.075,
                        width: _width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: const LinearGradient(
                              begin: Alignment(
                                  -0.03018629550933838, -0.02894212305545807),
                              end: Alignment(
                                  1.3960868120193481, 1.4281718730926514),
                              colors: [Color(0xff4a54be), Color(0xff48bc71)]),
                        ),
                        child: Center(
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  color: Colors.white, fontSize: _width * 0.04),
                            )),
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
                    height: _height * 0.2885,
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

  reset(String email) async {
    setState(() {
      _isLoading=true;
    });
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((data) {
        print("email send done");
        _showSnackBar('Password reset link sent to your email, check Spam');
        setState(() {
          _isLoading=false;
        });
        Transitioner(
          context: context,
          child: LoginScreen(),
          animation: AnimationType.slideLeft, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: false, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      });
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message.toString());
      setState(() {
        _isLoading=false;
      });
      return;
    }
  }

  Future<void> _showSnackBar(String msg) async {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
