import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_play/menu_screens/home_screens.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../../ad_helper.dart';
import '../../constants_services/colors_class.dart';
import '../../providers/user_provider.dart';
import 'edit_post_detail_screen.dart';

class EditPosts extends StatefulWidget {
  const EditPosts({Key? key}) : super(key: key);

  @override
  State<EditPosts> createState() => _EditPostsState();
}

class _EditPostsState extends State<EditPosts> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? stream;
  String? UniqueIDs;
  String? firebaseUuid;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    // _firebaseUniqueIDs();
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Transitioner(
                context: context,
                child: HomeScreen(),
                animation: AnimationType.slideLeft, // Optional value
                duration: Duration(milliseconds: 1000), // Optional value
                replacement: false, // Optional value
                curveType: CurveType.decelerate, // Optional value
              );
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  // _firebaseUniqueIDs() async{
  //   firebaseUuid = await FirebaseAuth.instance.currentUser!.email;
  //   print("firebaseUuid: $firebaseUuid");
  //   // _listener();
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AllColors.mainColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: height * 0.03,
            color: Colors.white,
          ),
        ),
        title: const Text("All Posts",
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
        // centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("data")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.length != 0
                  ? ListView.builder(
                      shrinkWrap: true, // outer ListView
                      // reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {

                            _loadInterstitialAd();
                            if (_interstitialAd != null) {
                              _interstitialAd?.show();
                            } else {
                              Transitioner(
                                context: context,
                                child: EditPostDetails(
                                  imageUrlE: snapshot.data.docs[index]['url'],
                                  description: snapshot.data.docs[index]
                                  ['description'],
                                  jobTitle: snapshot.data.docs[index]['title'],
                                  timePublished: snapshot.data.docs[index]
                                  ['time'],
                                  phone: snapshot.data.docs[index]['phone'],
                                  postedBy: snapshot.data.docs[index]['postedby'],
                                  chatId: snapshot.data.docs[index]['chat_id'],
                                  postId: snapshot.data.docs[index]['post_id'],
                                ),
                                animation:
                                AnimationType.slideLeft, // Optional value
                                duration: Duration(
                                    milliseconds: 1000), // Optional value
                                replacement: false, // Optional value
                                curveType: CurveType.decelerate, // Optional value
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.all(height * width * 0.0001),
                                child: Container(
                                  height: height * 0.3,
                                  width: width,
                                  decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data.docs[index]['url']),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              Container(
                                height: height * 0.04,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
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
                                height: height * 0.01,
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                    width: 427.5,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffbcbcbc))),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.5,
                            width: width * 0.5,
                            child: Image.asset("assets/images/emty_gify.gif"),
                          ),
                          Text("No Upload History",
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              )),
                        ],
                      ),
                    )
              : Center(
                child: CupertinoActivityIndicator(
                  color: Colors.black,
                ),
              );
        },
      ),
    );
  }

}
