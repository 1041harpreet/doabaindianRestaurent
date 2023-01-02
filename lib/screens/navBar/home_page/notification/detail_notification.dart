import 'package:flutter/material.dart';

import '../../../../config/config.dart';
import '../../../auth/sign_up_screen.dart';

Widget notificationItem(context,notificationprovider,index){
  return Material(
    color: AppConfig.secmainColor,
    child: InkWell(
      onTap: () {
        detail(context,notificationprovider,index);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppConfig.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/avatar.png',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(
                    "Your Order is ${notificationprovider.notificationList[index].status ? "Confirmed" : "Canceled"}" ,
                    style: TextStyle(
                      color: Color(0xffa58038),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Date :  ${notificationprovider.notificationList[index].date}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xffa58038)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:AppConfig.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white),
            )
          ],
        ),
      ),
    ),
  );
}
Future detail(context,np,index){
  bool status=true;
  final size=MediaQuery.of(context).size;
  return showModalBottomSheet(
    backgroundColor: AppConfig.secmainColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      builder: (builder) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
           status==false ?
            Column(children: [
            row("CANCEL ID","2345678934"),
            row("STATUS","FAILED"),],)
               : Column(children: [
              row("ORDER ID","${np.notificationList[index].orderID}"),
              row("EMAIL ID","${np.notificationList[index].email}"),
              row("DATE","${np.notificationList[index].date}"),
              row("Tax","${np.notificationList[index].tax}"),
              row("TOTAL","${np.notificationList[index].total}"),
              row("STATUS","Confirmed"),],),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(size,"DELETE",Colors.white,AppConfig.primaryColor,(){}),
            )
          ],
        );
      });
}

Widget row(key,value){
  return Padding(
    padding: const EdgeInsets.only(top: 8.0,left: 16.0),
    child: Row(children: [
      Text("${key} :",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17.0),),
      Text("${value} ",style: AppConfig.greytext,),

    ],),
  );
}