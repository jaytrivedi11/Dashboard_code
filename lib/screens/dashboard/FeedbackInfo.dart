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
                body: Row(
                  children: [
                    SizedBox(width: 50,),
                    FutureBuilder(
                      future: ApiService().getFeedbcakDetails(widget.feedbackId.toString()),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          Size size = MediaQuery.of(context).size;

                          FeedbackModel feedback = FeedbackModel.fromJson(jsonDecode(snapshot.data.toString()));
                            return Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),

                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                    

                                  SizedBox(height: 50,),

                                  RatingBar.builder(
                                  initialRating: feedback.stars?.toDouble()??0.0,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      case 0:
                                        return Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: Colors.red,
                                        );
                                      case 1:
                                        return Icon(
                                          Icons.sentiment_dissatisfied,
                                          color: Colors.redAccent,
                                        );
                                      case 2:
                                        return Icon(
                                          Icons.sentiment_neutral,
                                          color: Colors.amber,
                                        );
                                      case 3:
                                        return Icon(
                                          Icons.sentiment_satisfied,
                                          color: Colors.lightGreen,
                                        );
                                      case 4:
                                        return Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.green,
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                              ),
                                  SizedBox(height: defaultPadding,),
                                  Text(

                                    feedback.feedback.toString(),
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: defaultPadding,),


                                  Text(

                                   "Q1. How did you come to the police station?",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: defaultPadding,),
                                  Text(

                                    "Answer:${feedback.q1}",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: defaultPadding,),
                                  Text(

                                    "Q2. After how much time you were heard in PS",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: defaultPadding,),
                                  Text(
                                  "Answer:${feedback.q2}",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: defaultPadding,),

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
                  ],
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}
