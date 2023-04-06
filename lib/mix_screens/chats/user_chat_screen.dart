import 'dart:async';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_play/menu_screens/home_screens.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../../constants_services/colors_class.dart';
import '../../providers/user_provider.dart';

class UserChatScreen extends StatefulWidget {
  String PostID;
  UserChatScreen({Key? key, required this.PostID})
      : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  late TextEditingController _messageController;
  Stream? stream;
  String? imageUrl;

  _listener() {
    stream = _firestore
        .collection("Chat")
        .doc(widget.PostID)
        .collection("users")
        .orderBy("time", descending: true)
        .snapshots(); //retrieve all clients

    stream!.listen((data) {
      print(data.size);
    });
  }

  sendMessage(var message) async {
    _firestore.collection("Chat").doc(widget.PostID).collection("users").add({
      "message": message,
      "url":
      "https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg",
      "sender":   context.read<UserProvider>().UserEmail!.toString(),
      "time": DateTime.now().millisecondsSinceEpoch,
    });
  }



  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value );
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _listener();
  }

  @override
  void dispose() {
    _controller.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat",
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.white,
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
            color:  AllColors.mainColor,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                end: Alignment(1.3960868120193481, 1.4281718730926514),
                colors: [Color(0xff4a54be), Color(0xff48bc71)]),
          ),
        ),

      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return context.read<UserProvider>().UserEmail == snapshot.data.docs[index]
                    ['sender'] ? Padding(
                      padding: EdgeInsets.only(
                          top: _height * 0.05,
                          left: _width * 0.4,
                        ),
                      child: Row(
                        children: [
                          // CircleAvatar(
                          //   radius: _height * _width * 0.0001,
                          //   backgroundImage: NetworkImage(
                          //     snapshot.data.docs[index]['url'],
                          //   ),
                          // ),
                          SizedBox(
                            width: _width*0.1,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: _height*0.02,
                                ),
                                Text(snapshot.data.docs[index]
                                ['sender'],style: const TextStyle(
                                    color:  const Color(0xff202124),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Neckar",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 14.0
                                ),),
                                SizedBox(
                                  height: _height*0.01,
                                ),
                                BubbleSpecialOne(
                                  text: snapshot.data.docs[index]
                                  ['message'],
                                  isSender: false,
                                  color: Colors.purple.shade100,
                                  textStyle: const TextStyle(
                                      color:  const Color(0xff75787a),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Alexandria",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 12.0
                                  ),
                                ),
                                Text(
                                  parseTimeStamp(snapshot.data.docs[index]['time']),
                                  style: const TextStyle(
                                      color:  const Color(0xff75787a),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Alexandria",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 12.0
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Padding(
                      padding: EdgeInsets.only(
                          top: _height * 0.05,
                          left: _width * 0.01,
                          right: _width * 0.01),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: _height * _width * 0.0001,
                            backgroundImage: NetworkImage(
                              snapshot.data.docs[index]['url'],
                            ),
                          ),
                          SizedBox(
                            width: _width*0.1,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: _height*0.02,
                                ),
                                Text(snapshot.data.docs[index]
                                ['sender'],style: const TextStyle(
                                    color:  const Color(0xff202124),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Neckar",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 14.0
                                ),),
                                SizedBox(
                                  height: _height*0.01,
                                ),
                                BubbleSpecialOne(
                                  text: snapshot.data.docs[index]
                                  ['message'],
                                  isSender: false,
                                  color: Colors.green.shade200,
                                  textStyle: const TextStyle(
                                      color:  const Color(0xff75787a),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Alexandria",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 12.0
                                  ),
                                ),
                                Text(
                                  parseTimeStamp(snapshot.data.docs[index]['time']),
                                  style: const TextStyle(
                                      color:  const Color(0xff75787a),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Alexandria",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 12.0
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) ;
                  },
                ),
              ),
              MessageBar(
                onSend: (_) {
                  if (_messageController.text.isNotEmpty) {
                    sendMessage(_messageController.text);
                  } else {

                  }
                },
                onTextChanged: (data) {
                  _messageController.text = data;
                },
                // actions: [
                //   InkWell(
                //     child: Icon(
                //       Icons.add,
                //       color: Colors.black,
                //       size: 24,
                //     ),
                //     onTap: () {},
                //   ),
                //   Padding(
                //     padding: EdgeInsets.only(left: 8, right: 8),
                //     child: InkWell(
                //       child: Icon(
                //         Icons.camera_alt,
                //         color: Colors.green,
                //         size: 24,
                //       ),
                //       onTap: () {},
                //     ),
                //   ),
                // ],
              ),
            ],
          )
              : Container(
            child: Center(
              child: Text(
                "Chat Empty",
                style: const TextStyle(
                    color: const Color(0xff3a6c83),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
          );
        },
      ),
    );
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
