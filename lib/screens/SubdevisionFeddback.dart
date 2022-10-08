import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/MenuController.dart';
import '../models/PoliceStationList.dart';
import '../models/feedback.dart';
import '../network/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../network/ApiService.dart';
import '../responsive.dart';
import 'dashboard/components/header.dart';
import 'dashboard/components/recent_files.dart';
import 'dashboard/components/storage_details.dart';
import 'main/components/side_menu.dart';

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
    // getLevel();
    super.initState();
  }
  List<dynamic> list = [];
  String? stationId = "";
  // getLevel() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.containsKey("level")){
  //     level = prefs.getInt("level")!;
  //     var data = ApiService().getPoliceStationList();
  //     list = jsonDecode(await data);
  //     // time=PoliceStationList.fromJson(list[0]).sId;
  //     setState(() {
  //
  //     });
  //   }
  //
  // }
  List<dynamic> list1 = [];

  // Future<String> getStationId() async{
  //    data = ApiService().getFeedbackByDevision(time.toString());
  //   list1 = jsonDecode(data);
  //   print("list : ${list1}");
  //   setState(() {
  //
  //   });
  //
  //   return data;
  //
  // }


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

            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Scaffold(
                body: SingleChildScrollView(
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
                                      Row(
                                        children: [
                                          Text("       Setect PoliceStation     ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              )),
                                          Container(
                                            width:
                                            Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.8,
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
                                            child: FutureBuilder(
                                              future: ApiService().getPoliceStationList(),
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData){
                                                  List response = jsonDecode(snapshot.data.toString());
                                                  // if(stationId == ""){
                                                  //   stationId = response[0]["_id"];
                                                  // }
                                                  var list = response.map((e) => DropdownMenuItem(child: Text(e["name"]), value: e["_id"],)).toList();
                                                  list.insert(0, DropdownMenuItem(child: Text("Select"), value: "",));
                                                  print(list);
                                                  return DropdownButton(
                                                    items: list,
                                                    value: stationId,
                                                    isExpanded: true,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        stationId = value.toString();
                                                      });
                                                    }
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ),

                                          SizedBox(width: size.width/3,height: 50,),

                                          ElevatedButton(
                                              onPressed: (){

                                                if(stationId!=""){
                                                  generateExecel();
                                                }

                                              }, child: Container(
                                              alignment: Alignment.center,
                                              height: 40,
                                              width: 150,
                                              child: Text("Generate Excel File",style: TextStyle(fontSize: 15),))),
                                        ],
                                      ),
                                      SizedBox(height: defaultPadding),
                                      SingleChildScrollView(
                                        child: Column(
                                                  children: [

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
                                                              child: stationId != "" ? FutureBuilder<List>(
                                                                future: ApiService().getFeedbackUsingID(stationId!),
                                                                builder:(context, snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return DataTable2(
                                                                      // columnSpacing: defaultPadding,
                                                                      // minWidth: 600,
                                                                      columnSpacing: 0,
                                                                      dataRowHeight: 70,
                                                                      columns: [
                                                                        DataColumn(
                                                                          label: Text(
                                                                              "Sr.no"),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                              "Name"),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                              "Mobile no"),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                              "Date"),
                                                                        ),
                                                                        // DataColumn(
                                                                        //   label: Text("Police Station"),
                                                                        // ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                              "FeedBack"),
                                                                        ),
                                                                      ],
                                                                      rows: List
                                                                          .generate(
                                                                        snapshot.data!.length,
                                                                            (
                                                                            index) =>
                                                                            recentFileDataRow(
                                                                                FeedbackModel
                                                                                    .fromJson(
                                                                                    snapshot.data![index]),
                                                                                index,
                                                                                context),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                }
                                                              ): Container(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                      ),

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
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
  void generateExecel() async {


    var url = ApiConstants.baseUrl + ApiConstants.generateExcel + stationId!;

    html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
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
            // DropdownButton(
            //   items: List.generate(list.length, (index) =>DropdownMenuItem(value: "${FeedbackModel.fromJson(list[index]).name}", child: Text("${FeedbackModel.fromJson(list[index]).name}")), ),
            //   // items:
            //
            //   alignment: Alignment.center,
            //   isExpanded: true,
            //   value: time,
            //   underline: Container(),
            //   onChanged: ( value) {
            //     time = value.toString();
            //
            //     setState(() {
            //
            //       print(time);
            //     });
            //   },
            // ),


          ],
        ),
      )

    ];
  }
}
