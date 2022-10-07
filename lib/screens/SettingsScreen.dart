import 'package:admin/network/ApiConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import 'main/components/side_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class SettingsScreen extends StatefulWidget {
  const   SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {

  var stationID="";
  var policestationname="";
  var name="";
  var adress="";
  var emailid="";


  Future<bool> getStationId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     stationID = prefs.getString('stationID')!;
     policestationname = prefs.getString("name")!;
    name = prefs.getString("inspector")!;
    adress = prefs.getString("address")!;
    emailid = prefs.getString("email")!;
    print(name);

    setState(() {

    });

     if(stationID!=null){

       return true;

     }else{
       return false;
     }


  }
  @override
  void initState() {
    // TODO: implement initState
    getStationId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Scaffold(
                body: Center(
                  child: Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        width: Responsive.isDesktop(context) ? size.width * 0.7 : size.width,
                        height: Responsive.isDesktop(context) ?  700 : size.height,
                        child: Center(
                          child: Responsive.isDesktop(context) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: getChildren(size),
                          ) : SingleChildScrollView(
                            child: Column(
                              children: getChildren(size),
                            ),
                          ),
                        )
                      ),
                )
                // body: Center(
                //     child: ElevatedButton(
                //         onPressed: generateQR, child: Text("Generate QR"))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateQR() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stationID = prefs.getString('stationID');
    var url = ApiConstants.baseUrl + ApiConstants.generateQR + stationID!;

    html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
  
  getChildren(Size size){
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100,),
          Text(

            "Police Station name:",
            style: TextStyle(
                fontSize:  size.height * 0.030
            ),
          ),
          Container(
            width:
            Responsive.isDesktop(context) ? size.width *0.3 : size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: primaryColor,
                width: 0.5,
              ),
            ),
            child:
            Text(

              policestationname,
              style: TextStyle(color: Colors.grey
                  ,fontSize:  size.height * 0.040),
            ),
          ),
          SizedBox(height: 20,),
          Text(

            "Inspector Name :",
            style: TextStyle(
                fontSize:  size.height * 0.030),
          ),
          Container(
            width:
            Responsive.isDesktop(context) ? size.width *0.3 : size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: primaryColor,
                width: 0.5,
              ),
            ),
            child:
            Text(
              name,
              style: TextStyle(color: Colors.grey
                  ,fontSize:  size.height * 0.040),
            ),
          ),
          SizedBox(height: 20,),
          Text(

            "Email",
            style: TextStyle(
                fontSize:  size.height * 0.030),
          ),
          Container(
            width:
            Responsive.isDesktop(context) ? size.width *0.3 : size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: primaryColor,
                width: 0.5,
              ),
            ),
            child:
            Text(
              emailid,
              style: TextStyle(color: Colors.grey
                  ,fontSize:  size.height * 0.040),
            ),
          ),
          SizedBox(height: 20,),
          Text(

            "Adress",
            style: TextStyle(
                fontSize:  size.height * 0.030),
          ),
          Container(
            width:
            Responsive.isDesktop(context) ? size.width *0.3 : size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: primaryColor,
                width: 0.5,
              ),
            ),
            child:
            Text(
              adress,
              style: TextStyle(color: Colors.grey
                  ,fontSize:  size.height * 0.040),
            ),
          ),


        ],
      ),
      SizedBox(width: 200,),

      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 50,),
          FutureBuilder(
              future: getStationId(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return QrImage(
                    data:
                    'https://meek-sawine-c07b78.netlify.app/#form/${stationID}',
                    version: QrVersions.auto,
                    foregroundColor: Colors.grey,
                    size: 400,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xff128760),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xff1a5441),
                    ),

                  );
                }else{
                  return Container();
                }
              }
          ),
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
                onPressed: generateQR, child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 200,
                child: Text("Download Qr code",style: TextStyle(fontSize: 18),))),
          ),
        ],
      ),
    ];
  }
}
