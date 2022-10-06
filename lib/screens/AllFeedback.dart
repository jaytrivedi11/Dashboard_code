import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/MenuController.dart';
import '../models/feedback.dart';
import '../network/ApiService.dart';
import '../responsive.dart';
import 'dashboard/components/recent_files.dart';
import 'main/components/side_menu.dart';

class AllFeedback extends StatefulWidget {
  const AllFeedback({Key? key}) : super(key: key);

  @override
  State<AllFeedback> createState() => _AllFeedbackState();
}

class _AllFeedbackState extends State<AllFeedback> {
  var time = "weekly";
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
              child: SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: FutureBuilder(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
  getDropdown(Size size) {
    DateTime? datel;
    return [
      Text("       Select the Dates     ",
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
            DropdownButton<DateTime>(
              items: [
                'Choose A Date'
              ].map((e) => DropdownMenuItem<DateTime>(child: Text(e))).toList(),
              alignment: Alignment.center,
              isExpanded: true,
              value: datel,
              underline: Container(),
              onChanged: ( value) {
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2099)
                ).then((date) {

                  setState(() {
                    datel=date;

                  });
                });
                // time = value.toString();
                // setState(() {});
              },
            ),


          ],
        ),
      ),
      SizedBox(width: 10,),

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
              items: [
                const DropdownMenuItem(value: "weekly", child: Text("This Week")),
                const DropdownMenuItem(value: "monthly", child: Text("This Month")),
                const DropdownMenuItem(value: "yearly", child: Text("This Year")),
              ],
              alignment: Alignment.center,
              value: time,
              isExpanded: true,
              underline: Container(),
              onChanged: (value) {
                time = value.toString();
                setState(() {});
              },
            ),


          ],
        ),
      ),

    ];
  }
}

