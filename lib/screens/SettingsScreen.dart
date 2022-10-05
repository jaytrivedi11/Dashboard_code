import 'package:admin/network/ApiConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
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
                    child: ElevatedButton(
                        onPressed: generateQR, child: Text("Generate QR"))),
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
