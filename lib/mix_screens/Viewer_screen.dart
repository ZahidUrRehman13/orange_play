
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

// ignore: must_be_immutable
class ViewerScreen extends StatefulWidget {
 String? link;
  ViewerScreen({super.key,required this.link});

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
          const Color(0xffebf5f9)
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },

        ),
      )
      ..loadRequest(Uri.parse(widget.link.toString())
      );
    // changePDF();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      // appBar:  AppBar(
      //   backgroundColor: const Color(0xffebf5f9),
      //   elevation: 0.0,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.black54,
      //         size: height*width*0.00007,
      //       )),
      //   toolbarHeight: height*0.05,
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            _isLoading ? const Center( child: CupertinoActivityIndicator(),)
                : Stack(),
          ],
        ),
      ),

      // Center(
      //         child: _isLoading
      //             ? const Center(
      //                 child: CupertinoActivityIndicator(
      //                 ),
      //               )
      //             : SafeArea(
      //                 child: Stack(
      //                   children: [
      //                     PDFViewer(
      //                       document: document!,
      //                       zoomSteps: 1,
      //                       indicatorBackground: const Color(0xFF256D85),
      //                       lazyLoad: false,
      //                       scrollDirection: Axis.vertical,
      //                       showPicker: true,
      //                       progressIndicator: CupertinoActivityIndicator(),
      //                       pickerButtonColor: const Color(0xFF256D85),
      //                       showNavigation: true,  navigationBuilder:
      //                       (context, page, totalPages, jumpToPage, animateToPage) {
      //                     return Container(
      //                       color: Colors.white,
      //                       child: ButtonBar(
      //
      //                         alignment: MainAxisAlignment.spaceEvenly,
      //                         children: <Widget>[
      //                           IconButton(
      //                             icon: Icon(Icons.first_page,color: const Color(0xFF256D85),),
      //                             onPressed: () {
      //                               jumpToPage(page: 0);
      //                               // _controller!.clear();
      //                               // Navigator.pop(context);
      //                             },
      //                           ),
      //                           IconButton(
      //                             icon: Icon(Icons.arrow_back_ios,color: const Color(0xFF256D85),),
      //                             onPressed: () {
      //                               animateToPage(page: page! - 2);
      //                             },
      //                           ),
      //
      //                           IconButton(
      //                             icon: Icon(Icons.arrow_forward_ios,color: const Color(0xFF256D85),),
      //                             onPressed: () {
      //                               animateToPage(page: page);
      //                             },
      //                           ),
      //                           IconButton(
      //                             icon: Icon(Icons.last_page,color: const Color(0xFF256D85),),
      //                             onPressed: () {
      //                               jumpToPage(page: totalPages! - 1);
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   },
      //                     ),
      //                     Positioned(
      //                         top: _height * 0.03,
      //                         left: _width * 0.05,
      //                         child: GestureDetector(
      //                             onTap: () {
      //                               Navigator.pop(context);
      //                             },
      //                             child: Icon(
      //                               Icons.arrow_back_ios,
      //                               color: Color(0xFF256D85),
      //                             )))
      //                   ],
      //                 ),
      //               ),
      //       )
    ) ;
  }
}
