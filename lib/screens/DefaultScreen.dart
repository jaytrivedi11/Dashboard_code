import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import 'main/components/side_menu.dart';

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Responsive.isDesktop(context)
                          ? Row(
                              children: getChildren(size),
                            )
                          : SizedBox(
                              height: size.height * 0.7,
                              child: Column(
                                children: getChildren(size),
                              ),
                            ),

                      // Thre Weekly Chart
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: Responsive.isDesktop(context)
                            ? size.height * 0.65
                            : size.height * 0.85,
                        child: Card(
                          child: Center(
                            child: Text("Weekly Chart"),
                          ),
                        ),
                      ),

                      // Other Charts

                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: Responsive.isDesktop(context)
                            ? size.height * 0.65
                            : size.height * 1.6,
                        child: Responsive.isDesktop(context)
                            ? Row(children: getOtherData())
                            : Column(children: getOtherData()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getChildren(Size size) {
    return [
      Expanded(
        flex: 5,
        child: Container(
          height: Responsive.isDesktop(context)
              ? size.height * 0.25
              : size.height * 0.35,
          width: Responsive.isDesktop(context)
              ? size.width * 0.60
              : size.width * 1,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
              childAspectRatio: Responsive.isDesktop(context)
                  ? size.width / (size.height / 0.58)
                  : size.width / (size.height / 1.915),
            ),
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  child: Center(child: Text('Total Feedbacks')),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  child: Center(child: Text('Positive Feedbacks')),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  child: Center(child: Text('Neutral Feedbacks')),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  child: Center(child: Text('Negative Feedbacks')),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          margin: Responsive.isDesktop(context)
              ? EdgeInsets.only(top: 10, bottom: 10, right: 10)
              : EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          height: Responsive.isDesktop(context)
              ? size.height * 0.25
              : size.height * 0.45,
          child: Card(
            child: Center(
              child: Text("Stars"),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> getOtherData() {
    return [
      Expanded(
        child: Card(
          child: Center(
            child: Text("Other Chart"),
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Card(
          child: Center(
            child: Text("Other Chart"),
          ),
        ),
      ),
    ];
  }
}
