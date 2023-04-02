
import 'package:flutter/material.dart';
import '../constants_services/colors_class.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // GetNotificationsModel? _getNotificationsModel;

  @override
  void initState() {
    super.initState();
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
          InkWell(
            onTap: (){
            },
            child: const Center(
              child: Text("Clear All",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff313131),
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
      body:  const Center(
              child: Text(
                "Notifications Empty",
                style: TextStyle(
                    color:  Color(0xff313131),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              ),
            )
    );
  }

}
