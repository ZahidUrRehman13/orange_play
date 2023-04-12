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
import 'package:transitioner/transitioner.dart';
import 'package:uuid/uuid.dart';
import '../constants_services/colors_class.dart';
import '../providers/user_provider.dart';
import 'dart:io';

import 'home_screens.dart';

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
  final _nameKey = GlobalKey<FormFieldState>();


  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _nameController;
  var user;
  String? userID;
  bool _isProgress= false;
  String? profileUrl;
  String? firebaseUuid;

  @override
  void initState() {
    super.initState();
    uuid = Uuid();
    _generateUniqueIDs();
    initFirebase();
    initImageUrl();
    _firebaseUniqueIDs();
    _emailController = new TextEditingController();
    _phoneController = new TextEditingController();
    _nameController = new TextEditingController();

  }

  initImageUrl() async{
     await  FirebaseFirestore.instance
        .collection('Profile')
        .doc("images")
        .collection("data")
        .doc(context.read<UserProvider>().UserEmail)
        .get()
        .then((value) {
      setState(() {
        imageUrl = value.data()!["profile_image_url"]??"www.zahid.com";
        print('url_image_profile: $imageUrl');
      });
    });
  }

  initFirebase()async{

    user = await FirebaseAuth.instance.currentUser;
    _emailController!.text=FirebaseAuth.instance.currentUser!.email.toString();

  }

  _firebaseUniqueIDs() async{
    firebaseUuid = await FirebaseAuth.instance.currentUser!.uid;
    print("firebaseUuid: $firebaseUuid");
    _listener();
  }

  _listener() {
    var data = _firestore
        .collection("RegisterUser")
        .doc(firebaseUuid)
        .get()
        .then((DocumentSnapshot doc){
          _nameController!.text= doc.get("user_name");
          _phoneController!.text= doc.get("user_phone");
    } );

  }

  @override
  void dispose() {
    _emailController!.dispose();
    _phoneController!.dispose();
    _nameController!.dispose();
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
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.read<UserProvider>().setUserEmail("");
                navigate();
              },
              icon: Container(
                height: _height*0.04,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: const LinearGradient(
                        begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                        end: Alignment(1.3960868120193481, 1.4281718730926514),
                        colors: [Color(0xff1a51ba),Color(0xff48bc11)]),
                  ),
                  child: Icon(Icons.login_outlined,color: AllColors.mainColor,))),
          SizedBox(width: _width*0.02,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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

                        return snapshot.hasData && snapshot.data!.exists
                            ? _isLoading
                            ? CircleAvatar(
                          radius: _height * _width * 0.0002,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                            : Stack(
                          children: [
                            Positioned(
                              child: CircleAvatar(
                                radius: _height * _width * 0.0002,
                                backgroundImage: NetworkImage(snapshot
                                    .data!["profile_image_url"]
                                    .toString()),
                              ),
                            ),
                            Positioned(
                              child: CircleAvatar(
                                child: Icon(Icons.camera,color: Colors.white,),
                                radius: _height*_width*0.00005,),
                              top: _height*0.11,
                              left: _width*0.24,
                            )
                          ],
                        )
                            : _isLoading
                            ? CircleAvatar(
                          radius: _height * _width * 0.0002,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                            :  Stack(
                          children: [
                            Positioned(
                              child: CircleAvatar(
                                radius: _height * _width * 0.0002,
                                backgroundImage: NetworkImage(
                                    "https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg"),
                              ),
                            ),
                            Positioned(
                              child: CircleAvatar(
                                child: Icon(Icons.camera,color: Colors.white,),
                                radius: _height*_width*0.00005,),
                              top: _height*0.11,
                              left: _width*0.24,
                            )
                          ],
                        );

                      }),
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.05,
            ),
            Padding(
              padding:EdgeInsets.only(
                  top: _height * 0.04,
                  left: _width * 0.02,
                  right: _width * 0.02),
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
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(
                  top: _height * 0.04,
                  left: _width * 0.02,
                  right: _width * 0.02),
              child: TextFormField(
                key: _nameKey,
                controller: _nameController,
                keyboardType: TextInputType.text,
                textInputAction:
                TextInputAction.next,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(
                  top: _height * 0.04,
                  left: _width * 0.02,
                  right: _width * 0.02),
              child: TextFormField(
                key: _phoneKey,
                controller: _phoneController,
                keyboardType: TextInputType.text,
                textInputAction:
                TextInputAction.next,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black),
                    borderRadius:
                    BorderRadius.circular(1),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _height * 0.02,
            ),
            Visibility(
              visible: _isProgress,
              child: Container(
                height: _height * 0.05,
                child: Center(
                  child: CupertinoActivityIndicator(color: Colors.black,),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                updateEmail();
              },
              child: Padding(
                padding:EdgeInsets.only(
                    top: _height * 0.04,
                    left: _width * 0.02,
                    right: _width * 0.02),
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
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: _width * 0.04),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _generateUniqueIDs() {
    UniqueIDs = context.read<UserProvider>().UserEmail.toString() + uuid.v1();
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
      sendProfileImage();
    }
  }

  sendProfileImage() async {
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

  updateEmail() async{

    var url;

    setState(() {
       _isProgress=true;
     });

    FirebaseFirestore.instance
        .collection('Profile')
        .doc("images")
        .collection("data")
        .doc(context.read<UserProvider>().UserEmail)
        .get()
        .then((value) {
      setState(() {
        url = value.data()!["profile_image_url"];
        print('url_image_profile: $url');
      });
    });

    var auth = await FirebaseAuth.instance.currentUser;
    try {
      var usercred = await auth?.updateEmail(_emailController!.text.toString().trim());
      context.read<UserProvider>().setUserEmail(_emailController!.text.toString().trim());
      print('Email updated!!');



          _firestore
          .collection("Profile")
          .doc("images")
          .collection("data")
          .doc(context.read<UserProvider>().UserEmail)
          .set({
        "profile_image_url": url,
      });

      updateAll();




    } catch(err) {
      Fluttertoast.showToast(
        backgroundColor: Colors.black,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
        msg: "Network issue try again",);
      setState(() {
        _isProgress=false;
      });
      print(err);
    }
  }

  updateAll() async {

    _firestore
        .collection("User")
        .doc(firebaseUuid)
        .update({
      "user_email": _emailController!.text.trim().toString(),
      "user_name": _nameController!.text.trim().toString(),
      "user_phone": _phoneController!.text.trim().toString(),
    });

    Fluttertoast.showToast(
      backgroundColor: Colors.black,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
      msg: "Your Profile Updated Successfully",);


    setState(() {
      _isProgress=false;
    });
    navigate();
  }

  void navigate() {
    Transitioner(
      context: context,
      child: const HomeScreen(),
      animation: AnimationType.slideLeft, // Optional value
      duration: const Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
  }
}
