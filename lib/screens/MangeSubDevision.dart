import 'dart:convert';

import 'package:admin/network/ApiService.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';
import '../models/PoliceStationList.dart';
import '../responsive.dart';
import 'dashboard/components/header.dart';
import 'main/components/side_menu.dart';

class MangeSubDevision extends StatefulWidget {
  const MangeSubDevision({Key? key}) : super(key: key);

  @override
  State<MangeSubDevision> createState() => _MangeSubDevisionState();
}

class _MangeSubDevisionState extends State<MangeSubDevision> {

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
                     child:FutureBuilder(
                        future: ApiService().getPoliceStationList(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            List<dynamic> list = jsonDecode(snapshot.data.toString());
                            return Column(
                              children: [
                                DataTable2(
                                  // columnSpacing: defaultPadding,
                                  // minWidth: 600,
                                  columnSpacing: 0,
                                  dataRowHeight: 70,
                                  columns: [
                                    DataColumn(
                                      label: Text("Sr.no"),
                                    ),
                                    DataColumn(
                                      label: Text("Police Station"),
                                    ),
                                    DataColumn(
                                      label: Text("Inspector"),
                                    ),

                                  ],

                                  rows: List.generate(
                                    list.length,
                                        (index) => recentFileDataRow( PoliceStationList.fromJson(list[index]),index,context),
                                  ),
                                ),

                                ElevatedButton(
                                    onPressed: (){

                                    }, child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 200,
                                    child: Text("Download Qr code",style: TextStyle(fontSize: 18),))),
                              ],
                            );
                          }else{
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            );
                          }
                        }
                      )



                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  DataRow recentFileDataRow(PoliceStationList fileInfo,int position,BuildContext context) {
    return DataRow2(
      onTap: (){
        // Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider(
        //       create: (context) => MenuController(),
        //     ),
        //   ],
        //   child: FeedbackInfo(feedbackId: fileInfo.sId,),
        // ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);
      },
      cells: [
        DataCell(Text("${position + 1}")),
        DataCell(Text(fileInfo.name!)),

        DataCell(Text(fileInfo.inspector!)),
      ],
    );


  }

}
