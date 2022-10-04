import 'package:admin/network/ApiService.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    // ApiService().getStationDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: ApiService().getStationDetails(),
       builder: (context, snapshot) {
         if(snapshot.hasData){
           return SingleChildScrollView(
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
                           RecentFiles(),
                           if (Responsive.isMobile(context))
                             SizedBox(height: defaultPadding),
                           if (Responsive.isMobile(context)) StarageDetails(),
                         ],
                       ),
                     ),
                     if (!Responsive.isMobile(context))
                       SizedBox(width: defaultPadding),
                     // On Mobile means if the screen is less than 850 we dont want to show it
                     if (!Responsive.isMobile(context))
                       Expanded(
                         flex: 2,
                         child: StarageDetails(),
                       ),
                   ],
                 )
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
       },
      ),
    );
  }
}


