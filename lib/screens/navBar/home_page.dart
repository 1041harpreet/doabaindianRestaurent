import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/screens/home_page/category_detail_page.dart';
import 'package:restaurent_app/screens/navBar/category_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: hsize * .15, color: Colors.black54),
          Padding(
            padding: EdgeInsets.all(wsize * .03),
            child: SizedBox(
              height: hsize * .08,
              child: TextFormField(
                style: TextStyle(color: AppConfig.primaryColor),
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: AppConfig.primaryColor),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(wsize * .03),
                      borderSide: BorderSide(color: Colors.white)),
                  label: Text("Search for Lunch",
                      style: TextStyle(color: AppConfig.primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(wsize * .03),
                      borderSide: BorderSide(color: AppConfig.primaryColor)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(wsize * .03),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(wsize * .03),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: wsize * .05),
                child: Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: wsize * .05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetail(),
                      ));
                  print('pressed more');
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(right: wsize * .03, top: hsize * .01),
                  child: Text("More", style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(wsize * .03),
            child: SizedBox(
              height: hsize * .23,
              width: MediaQuery.of(context).size.width * 1,
              child: ListView.builder(
                itemCount: Const().categoryName.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(wsize * 0.02),
                      child: Container(
                            // height: hsize*.23,
                            width: wsize*.33,
                        child: Card(
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  buildImage(
                                      hsize,wsize, "assets/images/beverages.png"),
                                ],
                              ),
                              // Align(
                              //   alignment: Alignment.bottomCenter,
                              //   child: Container(
                              //     width: wsize*.33,
                              //     padding: EdgeInsets.all(4.0),
                              //     decoration: BoxDecoration(
                              //       color: AppConfig.primaryColor,
                              //       borderRadius: BorderRadius.circular(5),
                              //     ),
                              //     child: Text(Const().categoryName[index]),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      )

                      // Container(
                      //     height: hsize*.2,
                      //     width: wsize*.3,
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(wsize * 0.025),
                      //         boxShadow: [
                      //           BoxShadow(
                      //               offset: Offset(2.0, 2.0),
                      //               color: Colors.black26,
                      //               blurRadius: wsize * .025)
                      //         ],
                      //         image: DecorationImage(image: AssetImage('assets/images/beverages.png'))
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //
                      //         // Padding(
                      //         //   padding: EdgeInsets.only(
                      //         //       top: wsize * .01, left: wsize * .025),
                      //         //   child: Text(
                      //         //     Const().categoryName[index],
                      //         //     style: AppConfig.blackTitle,
                      //         //   ),
                      //         // ),
                      //
                      //       ],
                      //     ),),

                      );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

Widget buildImage(hsize, wsize,img) {
  return  Container(
    height: hsize*.2,
    width: wsize*.3,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(wsize * 0.025),
        boxShadow: [
          BoxShadow(
              offset: Offset(2.0, 2.0),
              color: Colors.black26,
              blurRadius: wsize * .025)
        ],

    ),
    child:
    ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.asset(
        img,
        fit: BoxFit.cover,
        // loadingBuilder: (context, Widget child, ImageChunkEvent progress) {
        //   if (progress == null) return child;
        //   return Center(
        //     child: Padding(
        //       padding: EdgeInsets.all(32),
        //       child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes : null),
        //     ),
        //   );
        // },
      ),
    )
  );
}
