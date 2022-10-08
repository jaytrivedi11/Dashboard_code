import 'dart:convert';

import 'package:admin/network/ApiService.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/MenuController.dart';
import '../models/PoliceStationList.dart';
import '../responsive.dart';
import 'dashboard/components/header.dart';
import 'main/components/side_menu.dart';

import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                                SizedBox(
                                  height: 100,
                                ),
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
                                SizedBox(
                                  height: 100,
                                ),

                                ElevatedButton(
                                    onPressed: (){
                                      _displayTextInputDialog(context);
                                    }, child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 250,
                                    child: Text("Add new police station",style: TextStyle(fontSize: 18),))),
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
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(

          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height / 3.5,
                width: width /2.5,
                child: Column(
                  children: [
                    SizedBox(
                      child: TextFormField(
                        style: kTextFormFieldStyle(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Police Station Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onChanged: (value){

                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          } else if (value.length < 4) {
                            return 'at least enter 4 characters';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      width: width*0.5,
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      child: TextFormField(
                        style: kTextFormFieldStyle(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Inspector Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onChanged: (value){

                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          } else if (value.length < 4) {
                            return 'at least enter 4 characters';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      width: width*0.5,
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      child: TextFormField(
                        style: kTextFormFieldStyle(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Email Id',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onChanged: (value){

                        },
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          } else if (value.length < 4) {
                            return 'at least enter 4 characters';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      width: width*0.5,
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(

                          child: Text('Button',style: TextStyle(fontSize: 20,color: Colors.red),),
                          onPressed: () {},

                        ),
                        SizedBox(width: 100,),
                        ElevatedButton(
                          child: Text('Button',style: TextStyle(fontSize: 20),),
                          onPressed: () {},

                        ),
                      ],
                    ),

                  ],
                ),
              );
            },
          ),
        )
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
