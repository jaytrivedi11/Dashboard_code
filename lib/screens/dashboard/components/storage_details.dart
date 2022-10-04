import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StarageDetails extends StatelessWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feedback Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: Colors.indigo,
            title: "Modrate",
            amountOfFiles: "",
            numOfFiles: 200,
          ),
          StorageInfoCard(
           svgSrc: Colors.green,
            title: "Positive",
            amountOfFiles: "",
            numOfFiles: 300,
          ),

          StorageInfoCard(
            svgSrc: Colors.red,
            title: "Nutral",
            amountOfFiles: "",
            numOfFiles: 100,
          ),
        ],
      ),
    );
  }
}
