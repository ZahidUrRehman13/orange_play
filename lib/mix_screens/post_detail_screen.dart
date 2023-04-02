import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_share_pro/open.dart';
import 'package:orange_play/Authentications/login_screen.darts.dart';
import 'package:orange_play/mix_screens/user_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';

import '../constants_services/colors_class.dart';
import '../providers/user_provider.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String? email;

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: AllColors.mainColor,
      body: SingleChildScrollView(

        child: SafeArea(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        height: height*0.4,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      top: height*0.01,
                        left: width*0.87,
                        child: GestureDetector(
                          onTap: (){
                            if(  context
                                .read<UserProvider>()
                                .UserEmail
                                .toString() != ""){
                              Transitioner(
                                context: context,
                                child:  UserChatScreen(PostID: '13'),
                                animation: AnimationType.fadeIn, // Optional value
                                duration:
                                const Duration(milliseconds: 1000), // Optional value
                                replacement: false, // Optional value
                                curveType: CurveType.decelerate, // Optional value
                              );
                            }else{
                              Transitioner(
                                context: context,
                                child: const LoginScreen(),
                                animation: AnimationType.slideLeft, // Optional value
                                duration:
                                const Duration(milliseconds: 1000), // Optional value
                                replacement: false, // Optional value
                                curveType: CurveType.decelerate, // Optional value
                              );
                            }
                          },
                          child: Icon(Icons.chat,color: Colors.green,
                          size: height*width*0.0001,),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: height*width*0.000045,
                      backgroundColor: const Color(0xff3a6c83),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg"),
                        radius: height*width*0.00004,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                            "Posted by:",
                            style: const TextStyle(
                                color:  const Color(0xff676767),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Lato",
                                fontStyle:  FontStyle.normal,
                                fontSize: 12.0
                            ),
                            textAlign: TextAlign.left
                        ),
                        SizedBox(width: width*0.02,),
                        Text("Joula Angella",style: const TextStyle(
                            color:  const Color(0xff202124),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Neckar",
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                        ),),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Open.mail(toAddress: "zahidrehman507@gmail.com", subject: "Orange Team", body: " ");
                      },
                      child: Column(
                        children: [

                          Container(
                              width: width*0.2,
                              height: height*0.03,
                              child:  Center(
                                child: Text(
                                  "Send Mail",
                                    style: const TextStyle(
                                        color:  const Color(0xff3a6c83),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Lato",
                                        fontStyle:  FontStyle.normal,
                                        fontSize: 12.0
                                    ),),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1)
                                  ),
                                  border: Border.all(
                                      color: const Color(0xff3a6c83),
                                      width: 2
                                  ),
                                  color: AllColors.mainColor
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("This is the finance minsiter advertisement"
                    " paper for checking the reality "
                    "of the people in the field"
                    " of ramadan in Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Ut arcu libero, pulvinar non massa sed, accumsan scelerisque dui. Morbi purus mauris, vulputate quis felis nec, fermentum aliquam orci. Quisque ornare iaculis placerat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In commodo sem arcu, sed fermentum tortor consequat vel. Phasellus lacinia quam quis leo tincidunt vehicula.",
                ),
              ),
              Opacity(
                opacity : 0.5,
                child:   Container(
                    width: 427.5,
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffbcbcbc)
                    )
                ),
              ),
              SizedBox(
                height: height*0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Advertisement Title:"),
                      SizedBox(height: height*0.03,),
                      Text("Posted Date & Time:",),

                    ],
                  ),
                  SizedBox(width: width*0.03,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Job Android Developer "),
                      SizedBox(height: height*0.03,),
                      Text("16/12/2023, 2:20 pm"),
                          ],
                  )

                ],
              ),
              SizedBox(height: height*0.03,),
              Center(
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),

                    ),
                    color:const Color(0xff3a6c83),
                    minWidth: width*0.7,
                    height: height*0.05,
                    onPressed: (){
                      _showSimpleDialog();

                    },
                    child:  Text("056 1150021",style: TextStyle(color: Colors.white,fontSize:width*0.04 ),)
                ),
              ),
              SizedBox(height: height*0.03,),

            ],
          ) ,
        ),
      ),
    );
  }


  Future<void> _showSimpleDialog() async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            contentPadding: EdgeInsets.all(width*0.1),
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Open.whatsApp(whatsAppNumber: "+971561150021", text: "Hi");
                  Navigator.pop(context);
                },
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Icon(Icons.whatsapp,color: Colors.green,),
                    SimpleDialogOption(
                      onPressed: () {
                        Open.whatsApp(whatsAppNumber: "+971561150021", text: "Hi");
                        Navigator.pop(context);
                      },
                      child: const Text('Open in Whatsapp'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height*0.03,),
              GestureDetector(
                onTap: (){
                  Open.phone(phoneNumber: "+971561150021");
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Icon(Icons.phone,color: Colors.green,),
                    SimpleDialogOption(
                      onPressed: () {
                        Open.phone(phoneNumber: "+971561150021");
                        Navigator.pop(context);
                      },
                      child: const Text('Phone Call'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height*0.03,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  if(  context
                      .read<UserProvider>()
                      .UserEmail
                      .toString() != ""){
                    Transitioner(
                      context: context,
                      child:  UserChatScreen(PostID: '13'),
                      animation: AnimationType.slideLeft, // Optional value
                      duration:
                      const Duration(milliseconds: 1000), // Optional value
                      replacement: false, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );

                  }else{
                    Transitioner(
                      context: context,
                      child: const LoginScreen(),
                      animation: AnimationType.slideLeft, // Optional value
                      duration:
                      const Duration(milliseconds: 1000), // Optional value
                      replacement: false, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Icon(Icons.chat,color: Colors.green,),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        if(  context
                            .read<UserProvider>()
                            .UserEmail
                            .toString() != ""){
                          Transitioner(
                            context: context,
                            child:  UserChatScreen(PostID: '13'),
                            animation: AnimationType.slideLeft, // Optional value
                            duration:
                            const Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );
                        }else{
                          Transitioner(
                            context: context,
                            child: const LoginScreen(),
                            animation: AnimationType.slideLeft, // Optional value
                            duration:
                            const Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );

                        }
                      },
                      child: const Text('Open Chat'),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }


}
