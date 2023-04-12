import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_share_pro/open.dart';
import 'package:orange_play/Authentications/login_screen.darts.dart';
import 'package:orange_play/mix_screens/chats/user_chat_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../constants_services/colors_class.dart';
import '../../menu_screens/home_screens.dart';
import '../../providers/user_provider.dart';

class EditPostDetails extends StatefulWidget {
  String imageUrlE;
  String description;
  String jobTitle;
  dynamic timePublished;
  String phone;
  String postedBy;
  String chatId;
  String postId;
  EditPostDetails(
      {Key? key,
      required this.imageUrlE,
      required this.description,
      required this.jobTitle,
      required this.timePublished,
      required this.phone,
      required this.postedBy,
      required this.chatId,
      required this.postId})
      : super(key: key);

  @override
  State<EditPostDetails> createState() => _EditPostDetailsState();
}

class _EditPostDetailsState extends State<EditPostDetails> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamController controller = StreamController();
  static var _random = new Random();
  static var _diceface = _random.nextInt(6) + 1;
  String? email;
  String? userID;
  File? imageFile;
  var pathImage;
  var imageUrl;
  bool _isLoading = false;

  final descriptionKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _titleKey = GlobalKey<FormFieldState>();
  TextEditingController? _descriptionController;
  TextEditingController? _phoneController;
  TextEditingController? _titleController;

  @override
  void initState() {
    super.initState();
    _descriptionController = new TextEditingController();
    _phoneController = new TextEditingController();
    _titleController = new TextEditingController();
    _descriptionController!.text = widget.description;
    _phoneController!.text = widget.phone;
    _titleController!.text = widget.jobTitle;
  }

  @override
  void dispose() {
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
      appBar: AppBar(
        backgroundColor: AllColors.mainColor,
        elevation: 0.0,
        title: const Text("Edit Post",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFFe4e6fb),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                end: Alignment(1.3960868120193481, 1.4281718730926514),
                colors: [Color(0xff4a54be), Color(0xff48bc71)]),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          InkWell(
            onTap: () {
              deletePost();
            },
            child:  Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text("Delete Post",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                  Container(
                      width: width*0.2,
                      height: 1,
                      decoration: BoxDecoration(
                          color:  Colors.white)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _getFromGallery();
                },
                child: Container(
                  height: height * 0.4,
                  width: width,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(widget.imageUrlE),
                          fit: BoxFit.fill)),
                  child: _isLoading ? CupertinoActivityIndicator(color: Colors.black,) : Container(
                    height: height * 0.1,
                    width: width * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.black12, shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                    width: 427.5,
                    height: 1,
                    decoration: BoxDecoration(color: const Color(0xffbcbcbc))),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.04,
                    left: width * 0.02,
                    right: width * 0.02),
                child: TextFormField(
                  key: descriptionKey,
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.04,
                    left: width * 0.02,
                    right: width * 0.02),
                child: TextFormField(
                  // key: _phoneKey,
                  controller: _phoneController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // labelText: widget.labelText,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.04,
                    left: width * 0.02,
                    right: width * 0.02),
                child: TextFormField(
                  key: _titleKey,
                  controller: _titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // labelText: widget.labelText,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                    width: 427.5,
                    height: 1,
                    decoration: BoxDecoration(color: const Color(0xffbcbcbc))),
              ),
              GestureDetector(
                onTap: () {
                  if (_descriptionController!.text.isNotEmpty &&
                      _phoneController!.text.isNotEmpty &&
                      _titleController!.text.isNotEmpty) {
                    updatePost();
                  } else {
                    Fluttertoast.showToast(
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      gravity: ToastGravity.CENTER,
                      msg: "Please fill all the fields",
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(height * width * 0.0001),
                  child: Center(
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.06,
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.04),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: const LinearGradient(
                            begin: Alignment(
                                -0.03018629550933838, -0.02894212305545807),
                            end: Alignment(
                                1.3960868120193481, 1.4281718730926514),
                            colors: [Color(0xff4a54be), Color(0xff48bc71)]),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
        _isLoading = true;
      });

      var snapshot = await _firebaseStorage
          .ref()
          .child(
              "images/Home/${FirebaseAuth.instance.currentUser!.email}/$_diceface/${context.read<UserProvider>().UserEmail}/$fileName")
          .putFile(imageFile!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        _isLoading = false;
      });
      _firestore
          .collection("Home")
          .doc("Upload")
          .collection("data")
          .doc(widget.postId)
          .update({
        "url": imageUrl,
      });

      _firestore
          .collection("User")
          .doc("Upload")
          .collection("data")
          .doc(widget.postId)
          .update({
        "url": imageUrl,
      });

      setState(() {});

      print("url_image$imageUrl");
    }
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

  updatePost() async {
    //home data updated
    _firestore
        .collection("Home")
        .doc("Upload")
        .collection("data")
        .doc(widget.postId)
        .update({
      "description": _descriptionController!.text.trim().toString(),
      "title": _titleController!.text.trim().toString(),
      // "url": imageUrl,
      "phone": _phoneController!.text.trim().toString(),
    });
    //user data updated
    _firestore
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("data")
        .doc(widget.postId)
        .update({
      "description": _descriptionController!.text.trim().toString(),
      "title": _titleController!.text.trim().toString(),
      // "url": imageUrl,
      "phone": _phoneController!.text.trim().toString(),
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

  deletePost() async {
    //home data updated
    _firestore
        .collection("Home")
        .doc("Upload")
        .collection("data")
        .doc(widget.postId)
        .delete();
    //user data updated
    _firestore
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("data")
        .doc(widget.postId)
        .delete();

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
