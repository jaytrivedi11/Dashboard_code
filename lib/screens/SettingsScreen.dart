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
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {

  var stationID;
  Future<bool> getStationId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     stationID = prefs.getString('stationID');

     if(stationID!=null){
       return true;
     }else{
       return false;
     }

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
                body: Row(
                  children: [
                    SizedBox(width: 50,),
                    Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      width:size.width*0.7,
                      height: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              'Gujarat Police',
                              style: kLoginTitleStyle(size),
                            ),
                          ),
                          FutureBuilder(
                            future: getStationId(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                  return QrImage(
                                    data:
                                        'https://meek-sawine-c07b78.netlify.app/#form/${stationID}',
                                    version: QrVersions.auto,
                                    foregroundColor: Colors.grey,
                                    size: 320,
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
                                    onPressed: generateQR, child: Text("Download")),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
}
