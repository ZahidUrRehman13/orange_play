import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:orange_play/menu_screens/profile_screen.dart';
import 'package:orange_play/mix_screens/Viewer_screen.dart';
import 'package:orange_play/mix_screens/posts/edit_post.dart';
import 'package:orange_play/mix_screens/posts/post_upload.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Authentications/login_screen.darts.dart';
import '../constants_services/colors_class.dart';
import '../mix_screens/posts/post_detail_screen.dart';
import '../providers/user_provider.dart';
import '../mix_screens/NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? stream;
  int count = 0;
  bool blackOrRed = false;
  int notificationCount = 0;
  String? UniqueIDs;

  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
  }

  _listener() {
    stream = _firestore
        .collection("Home")
        .doc("Upload")
        .collection("data")
        .orderBy("time", descending: true)
        .snapshots();

    stream!.listen((data) {
      print(data.size);
    });
  }

  sendNotificationsCount() async {
    _firestore
        .collection("NotificationsCount")
        .doc("count")
        .collection("data")
        .doc("Notifications")
        .set({
      "count": 0,
    });
  }

  @override
  void initState() {
    _listener();
    print("email ${context.read<UserProvider>().UserEmail.toString()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AllColors.mainColor,
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFe4e6fb),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.normal,
          ),
          textAlign: TextAlign.end,
        ),
        leading: Container(
          height: height * 0.02,
          width: width * 0.01,
          child: Container(
            height: height * 0.01,
            width: width * 0.01,
            child: Image.asset(
              "assets/images/app_bar_2.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment(-0.03018629550933838, -0.02894212305545807),
                end: Alignment(1.3960868120193481, 1.4281718730926514),
                colors: [Color(0xff4a54be), Color(0xff48bc71)]),
          ),
        ),
        // centerTitle: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Transitioner(
                    context: context,
                    child: const Notifications(),
                    animation: AnimationType.slideBottom, // Optional value
                    duration:
                        const Duration(milliseconds: 1000), // Optional value
                    replacement: false, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );

                  sendNotificationsCount();
                },
                icon: SvgPicture.asset(
                  "assets/svg/ontification_svg.svg", //asset location
                  color: const Color(0xFFe4e6fb),
                ),
              ),
              Positioned(
                  left: width * 0.07,
                  top: height * 0.005,
                  child: Container(
                    height: height * 0.026,
                    width: width * 0.053,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red),
                    child: Center(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('NotificationsCount')
                              .doc("count")
                              .collection("data")
                              .doc("Notifications")
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData && snapshot.data!.exists
                                ? Text(snapshot.data!["count"].toString())
                                : Text("0");
                          }),
                    ),
                  )),
            ],
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                    top: height * 0.02,
                    right: width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Advertise Your Business",
                        style: TextStyle(
                            color: Color(0xff313131),
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (context.read<UserProvider>().UserEmail == "" ||
                                context.read<UserProvider>().UserEmail ==
                                    null) {
                              Transitioner(
                                context: context,
                                child: const LoginScreen(),
                                animation:
                                AnimationType.slideLeft, // Optional value
                                duration: const Duration(
                                    milliseconds: 1000), // Optional value
                                replacement: false, // Optional value
                                curveType:
                                CurveType.decelerate, // Optional value
                              );
                            } else {

                              Transitioner(
                                context: context,
                                child: const AdvertisementPage(),
                                animation:
                                AnimationType.slideLeft, // Optional value
                                duration: const Duration(
                                    milliseconds: 1000), // Optional value
                                replacement: false, // Optional value
                                curveType:
                                CurveType.decelerate, // Optional value
                              );
                            }
                          },
                          child: SvgPicture.asset(
                              "assets/svg/arrow_forward_svg.svg", //asset location
                              color: Colors.black,
                              fit: BoxFit.scaleDown)),
                    ],
                  ),
                ),
                Container(
                    width: width,
                    margin: EdgeInsets.only(
                      left: width * 0.03,
                      top: height * 0.02,
                      right: width * 0.03,
                      bottom: height * 0.02,
                    ),
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xffa7a9b0)))
              ],
            ),
            StreamBuilder(
              stream: stream,
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true, // outer ListView
                        // reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              if (context.read<UserProvider>().UserEmail == "" ||
                                  context
                                      .read<UserProvider>()
                                      .UserEmail == null
                              ) {
                                Transitioner(
                                  context: context,
                                  child: const LoginScreen(),
                                  animation:
                                  AnimationType.slideLeft, // Optional value
                                  duration: const Duration(
                                      milliseconds: 1000), // Optional value
                                  replacement: false, // Optional value
                                  curveType:
                                  CurveType.decelerate, // Optional value
                                );
                              } else {

                                _Views(
                                    snapshot.data.docs[index]['views'],
                                    snapshot.data.docs[index]['post_id']
                                        .toString());
                                Transitioner(
                                  context: context,
                                  child: PostDetails(
                                    imageUrl: snapshot.data.docs[index]['url'],
                                    description: snapshot.data.docs[index]
                                    ['description'],
                                    jobTitle: snapshot.data.docs[index]
                                    ['title'],
                                    timePublished: snapshot.data.docs[index]
                                    ['time'],
                                    phone: snapshot.data.docs[index]['phone'],
                                    postedBy: snapshot.data.docs[index]
                                    ['postedby'],
                                    chatId: snapshot.data.docs[index]
                                    ['chat_id'],
                                  ),
                                  animation:
                                  AnimationType.slideLeft, // Optional value
                                  duration: Duration(
                                      milliseconds: 1000), // Optional value
                                  replacement: false, // Optional value
                                  curveType:
                                  CurveType.decelerate, // Optional value
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: height * 0.3,
                                      width: width,
                                      // decoration: BoxDecoration(
                                      //     // borderRadius: BorderRadius.circular(5),
                                      //     image: DecorationImage(
                                      //         image: NetworkImage(snapshot
                                      //             .data.docs[index]['url']),
                                      //         fit: BoxFit.fill)),
                                      child: CachedNetworkImage(
                                        filterQuality: FilterQuality.high,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        imageUrl: snapshot.data.docs[index]
                                            ['url'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                          color: Colors.black,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child:
                                                    Icon(Icons.error_outline)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                          width: 427.5,
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(),
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.7,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            border: Border.all(
                                                color: const Color(0xff3a6c83),
                                                width: 1),
                                            color: AllColors.mainColor),
                                        child: Center(
                                          child: Text(
                                            snapshot.data.docs[index]['title'],
                                            style: TextStyle(
                                                color: Color(0xff313131),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              sendLikes(
                                                  snapshot.data.docs[index]
                                                      ['likes'],
                                                  snapshot.data
                                                      .docs[index]['post_id']
                                                      .toString());
                                              setState(() {
                                                blackOrRed = true;
                                              });
                                            },
                                            child: Container(
                                                width: width * 0.1,
                                                height: height * 0.04,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.favorite,
                                                  color: blackOrRed
                                                      ? Colors.red
                                                      : Colors.black,
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(3)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff3a6c83),
                                                        width: 2),
                                                    color:
                                                        AllColors.mainColor)),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Share.share(
                                                  'https://play.google.com/store/apps/details?id=com.orange.play.orange_play');
                                            },
                                            child: Container(
                                                width: width * 0.1,
                                                height: height * 0.04,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.share,
                                                  color: Colors.blueAccent,
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(3)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff3a6c83),
                                                        width: 2),
                                                    color:
                                                        AllColors.mainColor)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                    width: width,
                                    height: 1,
                                    decoration:
                                        BoxDecoration(color: Colors.black)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.favorite_outline_outlined,
                                              size: width * 0.05,
                                            )),
                                        Text(
                                          "${snapshot.data.docs[index]['likes']} Likes",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              size: width * 0.05,
                                            )),
                                        Text(
                                          "${snapshot.data.docs[index]['views']} Views",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.mobile_screen_share,
                                              size: width * 0.05,
                                            )),
                                        Text(
                                          "${snapshot.data.docs[index]['likes']} Share",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                    width: width,
                                    height: 1,
                                    decoration:
                                        BoxDecoration(color: Colors.black)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.docs[index]['description'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                      width: 427.5,
                                      height: height * 0.02,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffbcbcbc))),
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        margin: EdgeInsets.only(top: height * 0.3),
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        duration: const Duration(milliseconds: 200),
        // distance: 60.0,
        type: ExpandableFabType.left,
        expandedFabSize: ExpandableFabSize.regular,
        // fanAngle: 70,
        child: const Icon(Icons.menu),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff4a54be),

        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff4a54aa),
        ),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 5,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.small(
            backgroundColor: Color(0xff4a51aa),
            heroTag: null,
            child: const Icon(Icons.edit),
            onPressed: () {
              if (context.read<UserProvider>().UserEmail == "" ||
                  context.read<UserProvider>().UserEmail == null) {
                Transitioner(
                  context: context,
                  child: const LoginScreen(),
                  animation: AnimationType.slideLeft, // Optional value
                  duration:
                      const Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              } else {
                Transitioner(
                  context: context,
                  child: EditPosts(),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              }
            },
          ),
          FloatingActionButton.small(
            backgroundColor: Color(0xff4a51aa),
            heroTag: null,
            child: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                  'https://play.google.com/store/apps/details?id=com.orange.play.orange_play');
            },
          ),
          FloatingActionButton.small(
            backgroundColor: Color(0xff4a51aa),
            heroTag: null,
            child: const Icon(Icons.person_pin),
            onPressed: () {
              if (context.read<UserProvider>().UserEmail == "" ||
                  context.read<UserProvider>().UserEmail == null) {
                Transitioner(
                  context: context,
                  child: const LoginScreen(),
                  animation: AnimationType.slideLeft, // Optional value
                  duration:
                  const Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              } else {
                Transitioner(
                  context: context,
                  child: ProfileScreen(),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );

              }

              // final state = key.currentState;
              // if (state != null) {
              //   debugPrint('isOpen:${state.isOpen}');
              //   state.toggle();
              // }
            },
          ),
        ],
      ),
    );
  }

  sendLikes(var oldValue, var post_id) async {
    int count = oldValue + 1;
    print("likes_count $count");
    _firestore
        .collection("Home")
        .doc("Upload")
        .collection("data")
        .doc(post_id)
        .update({
      "likes": count,
    });
  }

  _Views(var oldValue, var post_id) async {
    int count = oldValue + 1;
    print("views_count $count");
    _firestore
        .collection("Home")
        .doc("Upload")
        .collection("data")
        .doc(post_id)
        .update({
      "views": count,
    });
  }

  _launchUrl() async {
    var url = Uri.parse("https://novelflex.com/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
