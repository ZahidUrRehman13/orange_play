import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:orange_play/Authentications/login_screen.darts.dart';
import 'package:orange_play/constants_services/colors_class.dart';
import 'package:orange_play/menu_screens/home_screens.dart';
import 'package:orange_play/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';

import '../mix_screens/chats/user_chat_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _passwordKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();

  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPassword;
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  bool setobsureText = false;
  bool _isLoading = false;
  var credential;
  String? firebaseUuid;
  String? phone;
  String? country = '+971';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController!.dispose();
    _controllerEmail!.dispose();
    _controllerPassword!.dispose();
    _phoneController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
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

                  Container(
                    height: _height*0.2,
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
                      Text("Register",
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
                    height: _height * 0.05,
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
                              key: _nameKey,
                              controller: _nameController,
                              focusNode: _name,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              validator: validateName,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
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
                                hintText: "User Name",
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
                          Padding(
                            padding: EdgeInsets.only(
                              top: _height * 0.02,
                              left: _width * 0.035,
                              right: _width * 0.035,
                              bottom: _height * 0.02,
                            ),
                            child: Container(
                              height: _height * 0.1,
                              child: IntlPhoneField(
                                controller: _phoneController,
                                initialCountryCode: 'AE',
                                cursorColor: Colors.black12,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  errorMaxLines: 1,
                                  counterText: "",
                                  filled: true,
                                  fillColor: AllColors.mainColor,
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.red,
                                      )),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  hintText: "Verified Phone Number",
                                ),
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                  // _phoneController!.text = phone.completeNumber;
                                },
                                onCountryChanged: (phone) {
                                  print('Country code changed to: ' + phone.dialCode);
                                  country = phone.dialCode;
                                },
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
                  GestureDetector(
                    onTap: (){
                      handleLoginUser();
                    },
                    child: Padding(
                      padding:EdgeInsets.only(
                          top: _height * 0.01,
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
                            "Register",
                            style: TextStyle(
                                color: Colors.white, fontSize: _width * 0.04),
                          )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Transitioner(
                        context: context,
                        child: const LoginScreen(),
                        animation: AnimationType.slideLeft, // Optional value
                        duration:
                        const Duration(milliseconds: 1000), // Optional value
                        replacement: false, // Optional value
                        curveType: CurveType.decelerate, // Optional value
                      );
                    },
                    child: Padding(
                      padding:EdgeInsets.only(
                          top: _height * 0.05,
                          left: _width * 0.04,
                          right: _width * 0.04),
                      child: Container(
                        height: _height * 0.075,
                        width: _width ,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.all(Radius.circular(5)),
                        //   gradient: const LinearGradient(
                        //       begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                        //       end: Alignment(1.3960868120193481, 1.4281718730926514),
                        //       colors: [Color(0xff4a54be), Color(0xff48bc71)]),
                        // ),
                        child: Text(
                          "Already have an account Login",
                          style: TextStyle(
                              color: Colors.black, fontSize: _width * 0.04),
                          textAlign: TextAlign.center,
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
                    height: _height * 0.01,
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

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return "enter valid email";
    }
    else {
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
      Register();
    } else {}
  }

  void Register() async {
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

          _firebaseUniqueIDs();

          context
              .read<UserProvider>()
              .setUserEmail(value.user!.email.toString());
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 13.0
        );
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 13.0
        );
        setState(() {
          _isLoading = false;
        });
      }
  }
  }

  _firebaseUniqueIDs() async{
    firebaseUuid = await FirebaseAuth.instance.currentUser!.uid;
    print("firebaseUuid: $firebaseUuid");
    sendUserInfo();
  }

  sendUserInfo() async {
    _firestore
        .collection("User")
        .doc(firebaseUuid).set({
      "user_email": _controllerEmail!.text.trim().toString(),
      "user_name": _nameController!.text.trim().toString(),
      "user_phone": "${country! + _phoneController!.text}",

    });
    setState(() {
      _isLoading = false;
    });
    navigate();
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
