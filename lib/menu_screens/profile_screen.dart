import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../constants_services/colors_class.dart';
import '../providers/user_provider.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? imageFile;
  var pathImage;
  var imageUrl;
  bool _isLoading = false;
  var UniqueIDs;
  var uuid;
  Stream? stream;
  final _emailKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  var user;

  @override
  void initState() {
    super.initState();
    uuid = Uuid();
    _generateUniqueIDs();
    initFirebase();
    _emailController = new TextEditingController();
    _phoneController = new TextEditingController();
  }

  initFirebase()async{
    user = await FirebaseAuth.instance.currentUser;
    _emailController!.text=FirebaseAuth.instance.currentUser!.email.toString();
    _phoneController!.text=FirebaseAuth.instance.currentUser!.email.toString();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _phoneController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AllColors.mainColor,
      appBar: AppBar(
        backgroundColor: AllColors.mainColor,
        elevation: 0.0,
        title: const Text("My Profile",
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff313131),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: _height * 0.03,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: _height * 0.1),
              child: GestureDetector(
                onTap: () {
                  _getFromGallery();
                },
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Profile')
                        .doc("images")
                        .collection("data")
                        .doc(context.read<UserProvider>().UserEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _isLoading
                            ? CircleAvatar(
                                radius: _height * _width * 0.0002,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: _height * _width * 0.0002,
                                backgroundImage: NetworkImage(snapshot
                                    .data!["profile_image_url"]
                                    .toString()),
                              );
                      }
                      return CircleAvatar(
                        radius: _height * _width * 0.0002,
                        backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg"),
                      );
                    }),
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.05,
          ),
          Container(
            width: _width * 0.6,
            height: _height * 0.05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.transparent),
            child: Center(
              child: Text("${context.read<UserProvider>().UserEmail!}",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff313131),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
            ),
          ),
          SizedBox(
            height: _height * 0.15,
          ),
          Container(
            margin: EdgeInsets.only(
                top: _height * 0.04,
                left: _width * 0.02,
                right: _width * 0.02),
            height: _height * 0.07,
            width: _width * 0.95,
            child: TextFormField(
              key: _emailKey,
              controller: _emailController,
              keyboardType: TextInputType.text,
              textInputAction:
              TextInputAction.next,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFF256D85)),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFF256D85)),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: _height * 0.015,
                left: _width * 0.02,
                right: _width * 0.02),
            height: _height * 0.25,
            width: _width * 0.95,
            child: TextFormField(
              key: _phoneKey,
              controller: _phoneController,
              keyboardType:
              TextInputType.multiline,
              maxLines: 10,
              textInputAction:
              TextInputAction.next,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // labelText: widget.labelText,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFF256D85)),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xFF256D85)),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.15,
          ),
          GestureDetector(
            onTap: (){
              // resetEmail();
            },
            child: Container(
              height: _height * 0.05,
              width: _width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: const LinearGradient(
                    begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                    end: Alignment(1.3960868120193481, 1.4281718730926514),
                    colors: [Color(0xff4a54be), Color(0xff48bc71)]),
              ),
              child: Center(
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _generateUniqueIDs() {
    UniqueIDs = context.read<UserProvider>().UserEmail!.toString() + uuid.v1();
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
        _isLoading = true;
      });

      var snapshot = await _firebaseStorage
          .ref()
          .child(
              'Profile/images/Home/${context.read<UserProvider>().UserEmail}/$UniqueIDs/$fileName')
          .putFile(imageFile!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });

      print("profile_image_url:  $imageUrl");
      sendPost();
    }
  }

  sendPost() async {
    setState(() {
      _isLoading = true;
    });
    _firestore
        .collection("Profile")
        .doc("images")
        .collection("data")
        .doc(context.read<UserProvider>().UserEmail)
        .set({
      "profile_image_url": imageUrl,
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future resetEmail(String newEmail) async {


    var message;
    user!.updateEmail(newEmail)
        .then(
          (value) {
            message = 'Success';
            Fluttertoast.showToast(
            backgroundColor: Colors.black,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER,
            msg: "Your Email changed Successfully",);
          }
    )
        .catchError((onError) => message = 'error');
    return message;
  }
}
