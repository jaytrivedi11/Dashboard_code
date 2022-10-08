import 'dart:convert';

import 'package:admin/network/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../controllers/MenuController.dart';
import '../../models/feedback.dart';
import '../../responsive.dart';
import '../main/components/side_menu.dart';

class FeedbackInfo extends StatefulWidget {
  String? feedbackId;
   FeedbackInfo({Key? key,required this.feedbackId}) : super(key: key);

  @override
  State<FeedbackInfo> createState() => _FeedbackInfoState();
}

class _FeedbackInfoState extends State<FeedbackInfo> {

  var optionsQ1 = {
    "0": "Through a person known to a police officer",
    "1": "With a neighbour or local leader",
    "2": "On your own"
  };
  var optionsQ2 = {
    "0": "More than 15 minutes",
    "1": "15 minutes",
    "2": "10 minutes",
    "3": "5 minutes",
    "4": "Immediately"
  };


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
            // if (Responsive.isDesktop(context))
            //   Expanded(
            //     // default flex = 1
            //     // and it takes 1/6 part of the screen
            //     child: SideMenu(),
            //   ),
            Expanded(
              // It takes 5/6 part of the screen

              child: Scaffold(
                body:
                    FutureBuilder(
                      future: ApiService().getFeedbcakDetails(widget.feedbackId.toString()),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          Size size = MediaQuery.of(context).size;

                          FeedbackModel feedback = FeedbackModel.fromJson(jsonDecode(snapshot.data.toString()));
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),

                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                children:[


                                  SizedBox(height: 50,),
                                  Text("Feedback Details",
                                    style: TextStyle(
                                      fontSize: 35,
                                    ),

                                  ),
                                  SizedBox(height: 50,),
                                  Text("Feedback : ", style: TextStyle(fontSize: 22),),
                              Text(

                                feedback.feedback.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Estimated Feedback sentiment", style: TextStyle(fontSize: 22),),
                                  Text(
                                    feedback.sentiment.toString(),

                                    style: TextStyle(fontSize: 20),
                                  ),SizedBox(
                                    height: 20,
                                  ),
                              
                                  Text(

                                   "Answer for \"How did you come to the police station ?\""
                                      , style: TextStyle(fontSize: 22),
                                  ),
                                  Text(

                                    optionsQ1[feedback.q1.toString()]!,
                                    style: TextStyle(fontSize: 20),
                                  ),SizedBox(
                                    height: 20,
                                  ),
                                  Text(

                                    "Answer for \"After how much time you were heard in PS ?\""
                                    , style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                  optionsQ2[feedback.q2.toString()]!,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                              // RatingBar.builder(
                              //       initialRating: double.parse(feedback.stars.toString()),
                              //       itemCount: 5,
                              //
                              //       itemBuilder: (context, index) {
                              //         switch (index) {
                              //           case 0:
                              //             return Icon(
                              //               Icons.sentiment_very_dissatisfied,
                              //               color: Colors.red,
                              //             );
                              //           case 1:
                              //             return Icon(
                              //               Icons.sentiment_dissatisfied,
                              //               color: Colors.redAccent,
                              //             );
                              //           case 2:
                              //             return Icon(
                              //               Icons.sentiment_neutral,
                              //               color: Colors.amber,
                              //             );
                              //           case 3:
                              //             return Icon(
                              //               Icons.sentiment_satisfied,
                              //               color: Colors.lightGreen,
                              //             );
                              //           case 4:
                              //             return Icon(
                              //               Icons.sentiment_very_satisfied,
                              //               color: Colors.green,
                              //             );
                              //           default:
                              //             return Container();
                              //         }
                              //       },
                              //       onRatingUpdate: (rating) {
                              //         print(rating);
                              //       },
                              //   ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                    Text("Sender Details", style: TextStyle(
                                      fontSize: 35,
                                    ),
                                    ),
                                  Text("Name",  style: TextStyle(fontSize: 22),),
                                  Text(feedback.name!,
                                    style: TextStyle(fontSize: 20),),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Mobile Number", style: TextStyle(fontSize: 22),),
                                  Text(feedback.mobile!,
                                    style: TextStyle(fontSize: 20),),
                                ]
                              ),
                            );
                          }else{
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          );
                        }
                        }
                    ),

              ),
            ),
          ],
        ),
      ) ,
    );
  }
}
