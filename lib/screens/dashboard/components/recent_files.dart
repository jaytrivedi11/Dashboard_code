import 'dart:convert';

import 'package:admin/models/RecentFile.dart';
import 'package:admin/models/feedback.dart';
import 'package:admin/network/ApiService.dart';
import 'package:admin/screens/dashboard/FeedbackInfo.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/MenuController.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiService().getFeedbackByPolicestation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> list = jsonDecode(snapshot.data.toString());
            return Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      value="jay";

                    },
                  ),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          }
        });
  }
}

DataRow recentFileDataRow(FeedbackModel fileInfo,int position,BuildContext context) {
  return DataRow2(
    onTap: (){
      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: FeedbackInfo(feedbackId: fileInfo.sId,),
      ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);
    },
    cells: [
      DataCell(Text("${position + 1}")),
      DataCell(Text(fileInfo.name!)),
      DataCell(Text(fileInfo.mobile!)),
      DataCell(Text(
          DateFormat('dd-MM-yyyy').format(DateTime.parse(fileInfo.date!)))),
      // DataCell(Text(fileInfo.policestationID!)),
      DataCell(Text(fileInfo.feedback!)),
    ],
  );
}
