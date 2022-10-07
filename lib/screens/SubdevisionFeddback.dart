import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/PoliceStationList.dart';
import '../models/feedback.dart';
import '../network/ApiService.dart';
import '../responsive.dart';
import 'dashboard/components/header.dart';
import 'dashboard/components/recent_files.dart';
import 'dashboard/components/storage_details.dart';

class SubDevisionFeddback extends StatefulWidget {
  const SubDevisionFeddback({Key? key}) : super(key: key);

  @override
  State<SubDevisionFeddback> createState() => _SubDevisionFeddbackState();
}

class _SubDevisionFeddbackState extends State<SubDevisionFeddback> {
  int level = 0;


  @override
  void initState() {
    // TODO: implement initState
    getLevel();
    super.initState();
  }
  List<dynamic> list = [];
  String? time;
  getLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("level")){
      level = prefs.getInt("level")!;
      var data = ApiService().getPoliceStationList();
      list = jsonDecode(await data);
      time=PoliceStationList.fromJson(list[0]).name;
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return SafeArea(
      child: Column(
        children: [
          SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // MyFiles(),
                          SizedBox(height: defaultPadding),
                          FutureBuilder(
                              future: ApiService().getFeedbackByPolicestation(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> list = jsonDecode(snapshot.data.toString());
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        // height: 50,
                                      ),
                                      Responsive.isDesktop(context)
                                          ? Row(
                                          children: getDropdown(size)



                                      )
                                          : Column(
                                        children: getDropdown(size),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(defaultPadding),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Recent Feedback",
                                              style: Theme.of(context).textTheme.subtitle1,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                child: DataTable2(
                                                  // columnSpacing: defaultPadding,
                                                  // minWidth: 600,
                                                  columnSpacing: 0,
                                                  dataRowHeight: 70,
                                                  columns: [
                                                    DataColumn(
                                                      label: Text("Sr.no"),
                                                    ),
                                                    DataColumn(
                                                      label: Text("Name"),
                                                    ),
                                                    DataColumn(
                                                      label: Text("Mobile no"),
                                                    ),
                                                    DataColumn(
                                                      label: Text("Date"),
                                                    ),
                                                    // DataColumn(
                                                    //   label: Text("Police Station"),
                                                    // ),
                                                    DataColumn(
                                                      label: Text("FeedBack"),
                                                    ),
                                                  ],
                                                  rows: List.generate(
                                                    list.length,
                                                        (index) => recentFileDataRow( FeedbackModel.fromJson(list[index]),index,context),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  );
                                }
                              }),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context)) StarageDetails(),
                        ],
                      ),
                    ),

                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    //  if (!Responsive.isMobile(context))
                    //    Expanded(
                    //      flex: 2,
                    //      child: StarageDetails(),
                    //    ),
                  ],
                )
              ],
            ),
          )

        ],
      ),
    );

  }
  getDropdown(Size size) {
    DateTime? datel;

    return [
      Text("       Setect PoliceStation     ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),


      Container(
        width:
        Responsive.isDesktop(context) ? size.width * 0.1 : size.width * 0.8,
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
        child: Column(
          children: [
            DropdownButton(
              items: List.generate(list.length, (index) =>DropdownMenuItem(value: "${FeedbackModel.fromJson(list[index]).name}", child: Text("${FeedbackModel.fromJson(list[index]).name}")), ),
              // items:

              alignment: Alignment.center,
              isExpanded: true,
              value: time,
              underline: Container(),
              onChanged: ( value) {
                time = value.toString();

                setState(() {

                  print(time);
                });
              },
            ),


          ],
        ),
      )

    ];
  }
}
