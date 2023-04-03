import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import '../constants_services/colors_class.dart';
import '../providers/user_provider.dart';
import 'home_screens.dart';

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({Key? key}) : super(key: key);

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? imageFile;
  var pathImage;
  var imageUrl;
  bool _isLoading = false;
  static var _random = new Random();
  static var _diceface = _random.nextInt(6) + 1;
  final _bookTitleKey = GlobalKey<FormFieldState>();
  final _descriptionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phone;
  String? country = '+971';

  TextEditingController? _bookTitleController;
  TextEditingController? _descriptionController;
  TextEditingController? _phoneController;

  @override
  void initState() {
    super.initState();
    _bookTitleController = new TextEditingController();
    _descriptionController = new TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _bookTitleController!.dispose();
    _descriptionController!.dispose();
    _phoneController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AllColors.mainColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.04,
                        left: width * 0.02,
                        right: width * 0.02),
                    height: height * 0.07,
                    width: width * 0.9,
                    child: TextFormField(
                      key: _bookTitleKey,
                      controller: _bookTitleController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      validator: validateBookTitle,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xffebf5f9),
                        // labelText: widget.labelText,
                        hintText: "Product Name",
                        hintStyle: const TextStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.015,
                        left: width * 0.02,
                        right: width * 0.02),
                    height: height * 0.35,
                    width: width * 0.9,
                    child: TextFormField(
                      key: _descriptionKey,
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      validator: validateDescription,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffebf5f9),
                          // labelText: widget.labelText,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Description"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                      left: width * 0.06,
                      right: width * 0.06,
                      bottom: height * 0.05,
                    ),
                    child: Container(
                      height: height * 0.095,
                      child: IntlPhoneField(
                        controller: _phoneController,
                        initialCountryCode: 'AE',
                        cursorColor: Colors.black12,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          errorMaxLines: 1,
                          counterText: "",
                          filled: true,
                          fillColor: Color(0xffebf5f9),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          hintText: "Contact Number",
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
                  GestureDetector(
                    onTap: () async {
                      _getFromGallery();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: width * 0.01, right: width * 0.01),
                      height: height * 0.35,
                      width: width * 0.9,
                      child: Center(
                        child: pathImage == null
                            ? Container(
                                margin: EdgeInsets.only(left: width * 0.01),
                                height: height * 0.35,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xffebf5f9),
                                ),
                                child: Center(
                                  child: Text(
                                    "Advertisement Image ",
                                    style: const TextStyle(),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(pathImage!),
                                  fit: BoxFit.cover,
                                  colorBlendMode: BlendMode.saturation,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.black12),
                                      child: Center(
                                        child: Text(
                                          "Advertisement Image",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: const Color(0xff3a6c83),
                      minWidth: width * 0.9,
                      height: height * 0.07,
                      onPressed: () {
                        if (imageUrl == "" || imageUrl == null) {
                          Fluttertoast.showToast(
                              backgroundColor: Colors.black,
                            textColor: Colors.white,
                            gravity: ToastGravity.CENTER,
                            msg: "Please upload Image first",);
                        } else {
                          if (_descriptionController!.text.isNotEmpty &&
                              _bookTitleController!.text.isNotEmpty &&
                              imageUrl.isNotEmpty &&
                              _phoneController!.text.isNotEmpty) {
                            sendPost();
                          } else {

                            Fluttertoast.showToast(
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              gravity: ToastGravity.CENTER,
                              msg: "Please fill all the fields",);
                          }
                        }
                      },
                      child: Text(
                        "Advertise",
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.04),
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
            Positioned(
                left: width * 0.45,
                right: width * 0.45,
                top: height * 0.45,
                child: Visibility(
                    visible: _isLoading,
                    child: CupertinoActivityIndicator(
                      color: Colors.black,
                    )))
          ],
        ),
      ),
    );
  }

  _getFromGallery() async {


    final _firebaseStorage = FirebaseStorage.instance;

    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile = File(image.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final fileName = path.basename(imageFile!.path);
      final File localImage = await imageFile!.copy('$appDocPath/$fileName');

      // prefs!.setString("image", localImage.path);
      setState(() {
        imageFile = File(image.path);
        _savePath(localImage.path);
        _retrievePath();
        _isLoading=true;
      });

      var snapshot = await _firebaseStorage
          .ref()
          .child(
              'images/Home/$_diceface/${context.read<UserProvider>().UserEmail}/$fileName')
          .putFile(imageFile!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        _isLoading = false;
      });

      print("url_image$imageUrl");
    }
  }

  sendPost() async {
    setState(() {
      _isLoading = true;
    });
    _firestore
        .collection("Home")
        .doc(context.read<UserProvider>().UserEmail!.toString())
        .collection("data")
        .add({
      "description": _descriptionController!.text.trim().toString(),
      "title": _bookTitleController!.text.trim().toString(),
      "time": DateTime.now().millisecondsSinceEpoch,
      "url": imageUrl,
      "phone": "${country! + _phoneController!.text}",
      "postedby": context.read<UserProvider>().UserEmail!.toString(),
      "chat_id": context.read<UserProvider>().UserEmail!.toString()+_diceface.toString(),
    });
    setState(() {
      _isLoading = false;
    });

    Transitioner(
      context: context,
      child: const HomeScreen(),
      animation: AnimationType.slideLeft, // Optional value
      duration: const Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
  }

  Future<void> _retrievePath() async {
    final prefs = await SharedPreferences.getInstance();

    // Check where the name is saved before or not
    if (!prefs.containsKey('path_img')) {
      return;
    }

    setState(() {
      pathImage = prefs.getString('path_img');
      // log("Index number is: ${pathImage.toString()}");
    });
  }

  Future<void> _savePath(var _pathFine) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('path_img', _pathFine);
    });
  }

  String? validateBookTitle(String? value) {
    if (value!.isEmpty)
      return 'Enter Book Title';
    else
      return null;
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty)
      return 'Enter Description';
    else
      return null;
  }
}
