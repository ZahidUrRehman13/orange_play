import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_play/mix_screens/posts/post_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../constants_services/colors_class.dart';
import '../providers/user_provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? stream;

  @override
  void initState() {
    _listener();

    super.initState();
  }

  _listener() {
    stream = _firestore
        .collection("Notifications")
        .doc("main")
        .collection("data")
        .orderBy("time", descending: true)
        .snapshots(); //retrieve all clients

    stream!.listen((data) {
      print(data.size);
    });
  }


  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
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
        toolbarHeight: _height * 0.07,
        title: const Text("Notifications",
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
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
            size: _height * 0.03,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: const Center(
              child: Text("Clear All",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
            ),
          ),
          SizedBox(
            width: _width * 0.03,
          )
        ],
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.length == 0
                  ? Center(
                      child: Text(
                        "Notifications Empty",
                        style: TextStyle(
                            color: Color(0xff313131),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {

                            // Transitioner(
                            //   context: context,
                            //   child: PostDetails(
                            //     imageUrl: snapshot.data.docs[index]['url'],
                            //     description: snapshot.data.docs[index]
                            //     ['description'],
                            //     jobTitle: snapshot.data.docs[index]
                            //     ['title'],
                            //     timePublished: snapshot.data.docs[index]
                            //     ['time'],
                            //     phone: snapshot.data.docs[index]['phone'],
                            //     postedBy: snapshot.data.docs[index]
                            //     ['postedby'],
                            //     chatId: snapshot.data.docs[index]
                            //     ['chat_id'],
                            //   ),
                            //   animation:
                            //   AnimationType.slideLeft, // Optional value
                            //   duration: Duration(
                            //       milliseconds: 1000), // Optional value
                            //   replacement: false, // Optional value
                            //   curveType:
                            //   CurveType.decelerate, // Optional value
                            // );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: _height * 0.02,
                                    bottom: _height * 0.03),
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                      width: _width,
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffbcbcbc))),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // Container(
                                    //   height: _height * 0.1,
                                    //   width: _width * 0.15,
                                    //   decoration: BoxDecoration(
                                    //       shape: BoxShape.rectangle,
                                    //       image: DecorationImage(
                                    //           image: snapshot.data.docs[index]
                                    //                       ['url'] ==
                                    //                   " "
                                    //               ? AssetImage(
                                    //                   "assets/Novelflex_main.png")
                                    //               : NetworkImage(snapshot.data
                                    //                       .docs[index]['url']
                                    //                       .toString())
                                    //                   as ImageProvider,
                                    //           fit: BoxFit.cover)),
                                    // ),
                                    Container(
                                      width: _width * 0.4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text("New Advertisement Posted",
                                          //     style: TextStyle(
                                          //       fontFamily: 'Poppins',
                                          //       color: Colors.black,
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.w800,
                                          //       fontStyle: FontStyle.normal,
                                          //     )),
                                          Text(
                                            snapshot.data.docs[index]['title'],
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Neckar",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(
                                            height: _height * 0.01,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['description'],
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Neckar",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(
                                            height: _height * 0.03,
                                          ),
                                          Text(
                                              parseTimeStamp(snapshot.data.docs[index]
                                              ['time'])
                                            ,
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Neckar",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: _height * 0.09,
                                      width: _width * 0.2,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data.docs[index]['url']),
                                              fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       top: _height * 0.01,
                              //       bottom: _height * 0.01),
                              //   child: Opacity(
                              //     opacity: 0.5,
                              //     child: Container(
                              //         width: _width,
                              //         height: 1,
                              //         decoration: BoxDecoration(
                              //             color:
                              //                 const Color(0xffbcbcbc))),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      },
                    )
              : Container(
                  margin: EdgeInsets.only(top: _height * 0.3),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
