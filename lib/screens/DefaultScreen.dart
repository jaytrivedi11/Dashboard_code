import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/network/ApiConstant.dart';
import 'package:admin/network/ApiService.dart';
import 'package:admin/screens/dashboard/components/recent_files.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import 'main/components/side_menu.dart';
import 'package:http/http.dart' as http;

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  bool isLoading = true;
  bool isNumLoading = true;
  var id = "";
  var time = "weekly";
  var place = "";
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
  void initState() {
    getID();
    super.initState();
  }

  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("level")) {
      switch (prefs.getInt("level")) {
        case 0:
          setState(() {
            isLoading = false;
            id = prefs.getString("stationID")!;
            place = "station";
          });
          break;
        case 1:
          setState(() {
            isLoading = false;
            id = prefs.getString("subdivisionID")!;
            place = "subdivision";
          });
          break;
        case 2:
          setState(() {
            isLoading = false;
            id = prefs.getString("districtID")!;
            place = "district";
          });
      }
      getNumbers();
    }
  }

  getNumbers() async {
    var total = await http.get(Uri.parse(""));
  }

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
                  child: Column(
                    children: [
                      Responsive.isDesktop(context)
                          ? Row(
                              children: getChildren(size),
                            )
                          : SizedBox(
                              height: size.height * 0.7,
                              child: Column(
                                children: getChildren(size),
                              ),
                            ),

                      // Thre Weekly Chart
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: Responsive.isDesktop(context)
                            ? size.height * 0.65
                            : size.height * 0.85,
                        child: Card(
                          color: secondaryColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                    // height: 50,
                                    ),
                                Responsive.isDesktop(context)
                                    ? Row(
                                        children: getDropdown(size),
                                      )
                                    : Column(
                                        children: getDropdown(size),
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                place == "station"
                                    ? FutureBuilder<http.Response>(
                                        future: http.get(Uri.parse(
                                          ApiConstants.baseUrl +
                                              ApiConstants.chartRoute +
                                              time +
                                              ApiConstants.stationRoute +
                                              id,
                                        )),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<WeeklyFrequency>
                                                frequencyData = [];
                                            Map res =
                                                jsonDecode(snapshot.data!.body);
                                            res.forEach(
                                              (key, value) {
                                                frequencyData.add(
                                                    WeeklyFrequency(
                                                        date: key,
                                                        count: value));
                                              },
                                            );

                                            return Container(
                                              height: size.height * 0.5,
                                              child: SafeArea(
                                                child: SfCartesianChart(
                                                  primaryXAxis: CategoryAxis(),
                                                  primaryYAxis:
                                                      NumericAxis(interval: 1),
                                                  series: [
                                                    LineSeries<WeeklyFrequency,
                                                        String>(
                                                      dataSource: frequencyData,
                                                      xValueMapper:
                                                          (datum, index) =>
                                                              datum.date,
                                                      yValueMapper:
                                                          (datum, index) =>
                                                              datum.count,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : place == "subdivision"
                                        ? FutureBuilder<http.Response>(
                                            future: http.get(Uri.parse(
                                              ApiConstants.baseUrl +
                                                  ApiConstants.chartRoute +
                                                  time +
                                                  ApiConstants
                                                      .frequencyForStation +
                                                  id,
                                            )),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                // List<WeeklyFrequency>
                                                //     frequencyData = [];
                                                // Map res = jsonDecode(
                                                //     snapshot.data!.body);
                                                // res.forEach(
                                                //   (key, value) {
                                                //     frequencyData.add(
                                                //         WeeklyFrequency(
                                                //             date: key,
                                                //             count: value));
                                                //   },
                                                // );

                                                List<List<MultiFrequency>>
                                                    frequencyData = [];

                                                List res = jsonDecode(
                                                    snapshot.data!.body);

                                                for (var i = 0;
                                                    i < res.length;
                                                    i++) {
                                                  Map data = res[i]["data"];
                                                  String name = res[i]["name"];
                                                  List<MultiFrequency> temp =
                                                      [];
                                                  data.forEach((key, value) {
                                                    temp.add(MultiFrequency(
                                                        date: key,
                                                        count: value,
                                                        name: name));
                                                  });
                                                  frequencyData.add(temp);
                                                }

                                                return Container(
                                                  height: size.height * 0.5,
                                                  child: SafeArea(
                                                    child: SfCartesianChart(
                                                      primaryXAxis:
                                                          CategoryAxis(
                                                        labelStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyText1,
                                                      ),
                                                      primaryYAxis: NumericAxis(
                                                          labelStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                          interval: 1),
                                                      series: List.generate(
                                                          frequencyData.length,
                                                          (index) {
                                                        return LineSeries<
                                                            MultiFrequency,
                                                            String>(
                                                          name: frequencyData[
                                                                  index]
                                                              .first
                                                              .name,
                                                          dataSource:
                                                              frequencyData[
                                                                  index],
                                                          xValueMapper:
                                                              (datum, index) =>
                                                                  datum.date,
                                                          yValueMapper:
                                                              (datum, index) =>
                                                                  datum.count,
                                                          dataLabelMapper:
                                                              (datum, index) =>
                                                                  datum.count
                                                                      .toString(),
                                                        );
                                                      }),
                                                      legend: Legend(
                                                        isVisible: true,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyText1,
                                                      ),
                                                      tooltipBehavior:
                                                          TooltipBehavior(
                                                              enable: true),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Other Charts

                      place == "station"
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              height: Responsive.isDesktop(context)
                                  ? size.height * 0.65
                                  : size.height * 1.6,
                              child: Responsive.isDesktop(context)
                                  ? Row(children: getOtherData(size))
                                  : Column(children: getOtherData(size)),
                            )
                          : Container(),
                      place == "station"
                          ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: RecentFiles(),
                            )
                          : Container(),
                      place == "subdivision"
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              // height: Responsive.isDesktop(context)
                              //     ? size.height * 0.65
                              //     : size.height * 1.6,
                              child: Card(
                                color: secondaryColor,
                                child: Center(
                                  child: FutureBuilder<http.Response>(
                                    future: http.get(Uri.parse(
                                      ApiConstants.baseUrl +
                                          ApiConstants.chartRoute +
                                          "average/stations/" +
                                          id,
                                    )),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<AverageFrequency> frequencyData =
                                            [];
                                        List res =
                                            jsonDecode(snapshot.data!.body);

                                        res.forEach((element) {
                                          frequencyData.add(AverageFrequency(
                                            name: element[0],
                                            count: double.parse(element[1]
                                                .toString()
                                                .substring(0, 1)),
                                          ));
                                        });

                                        return Container(
                                          padding: EdgeInsets.all(25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Average stars per station",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SafeArea(
                                                child: SfCartesianChart(
                                                  primaryXAxis: CategoryAxis(
                                                    isInversed: true,
                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                  primaryYAxis: NumericAxis(
                                                    interval: 1,
                                                    maximum: 5,
                                                    minimum: 0,
                                                    opposedPosition: true,
                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                  ),
                                                  series: [
                                                    BarSeries<AverageFrequency,
                                                        String>(
                                                      dataSource: frequencyData,
                                                      xValueMapper:
                                                          (datum, index) =>
                                                              datum.name,
                                                      yValueMapper:
                                                          (datum, index) =>
                                                              datum.count,
                                                      dataLabelMapper:
                                                          (datum, index) =>
                                                              datum.count
                                                                  .toString(),
                                                      dataLabelSettings:
                                                          DataLabelSettings(
                                                              isVisible: true),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Container(),

                      place == "subdivision"
                          ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        // height: Responsive.isDesktop(context)
                        //     ? size.height * 0.65
                        //     : size.height * 1.6,
                        child: Card(
                          color: secondaryColor,
                          child: Center(
                            child: FutureBuilder<http.Response>(
                              future: http.get(Uri.parse(
                                ApiConstants.baseUrl +
                                    ApiConstants.chartRoute +
                                    time + ApiConstants.dataForSentimentChart +
                                    id,
                              )),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print(snapshot.data!.body);
                                  List<AverageFrequency> positiveData =
                                  [];
                                  List<AverageFrequency> neutralData = [];
                                  List<AverageFrequency> negativeData = [];
                                  Map res =
                                  jsonDecode(snapshot.data!.body);

                                  res.forEach((key, value) {
                                    positiveData.add(AverageFrequency(name: key, count: value["Positive"]));
                                  },);

                                  res.forEach((key, value) {
                                    neutralData.add(AverageFrequency(name: key, count: value["Neutral"]));
                                  },);

                                  res.forEach((key, value) {
                                    negativeData.add(AverageFrequency(name: key, count: value["Negative"]));
                                  },);

                                  return Container(
                                    padding: EdgeInsets.all(25),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Sentiment Analysis per station",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SafeArea(
                                          child: SfCartesianChart(
                                            primaryXAxis: CategoryAxis(
                                              isInversed: true,
                                              labelStyle:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            primaryYAxis: NumericAxis(
                                              interval: 1,
                                              opposedPosition: true,
                                              labelStyle:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            series: [
                                              BarSeries<AverageFrequency, String>(dataSource: positiveData, xValueMapper: (datum, index) => datum.name, yValueMapper: (datum, index) => datum.count, color: Colors.green, dataLabelMapper:
                                                  (datum, index) =>
                                                  datum.count
                                                      .toString(),
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true),
                                                name: "Positive"
                                              ),
                                              BarSeries<AverageFrequency, String>(dataSource: neutralData, xValueMapper: (datum, index) => datum.name, yValueMapper: (datum, index) => datum.count, color: Colors.blue, dataLabelMapper:
                                                  (datum, index) =>
                                                  datum.count
                                                      .toString(),
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true),
                                                name: "Neutral"
                                              ),
                                              BarSeries<AverageFrequency, String>(dataSource: negativeData, xValueMapper: (datum, index) => datum.name, yValueMapper: (datum, index) => datum.count, color: Colors.red, dataLabelMapper:
                                                  (datum, index) =>
                                                  datum.count
                                                      .toString(),
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true),
                                                name: "Negative",
                                              )
                                            ],
                                            legend: Legend(
                                              isVisible: true,
                                              textStyle:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 1,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      )
                          : Container(),
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

  List<Widget> getChildren(Size size) {
    return [
      Expanded(
        flex: 5,
        child: Container(
          height: Responsive.isDesktop(context)
              ? size.height * 0.25
              : size.height * 0.35,
          width: Responsive.isDesktop(context)
              ? size.width * 0.60
              : size.width * 1,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
              childAspectRatio: Responsive.isDesktop(context)
                  ? size.width / (size.height / 0.58)
                  : size.width / (size.height / 1.915),
            ),
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  color: secondaryColor,
                  child: Center(
                    child: FutureBuilder<http.Response>(
                      future: http.get(
                        place == "station"
                            ? Uri.parse(
                                ApiConstants.baseUrl +
                                    ApiConstants.chartRoute +
                                    time +
                                    ApiConstants.totalFeedbackStation +
                                    id,
                              )
                            : place == "subdivision"
                                ? Uri.parse(
                                    ApiConstants.baseUrl +
                                        ApiConstants.chartRoute +
                                        time +
                                        ApiConstants.totalFeedbackSubdivision +
                                        id,
                                  )
                                : Uri.parse(
                                    ApiConstants.baseUrl +
                                        ApiConstants.chartRoute +
                                        time +
                                        ApiConstants.totalFeedbackDistrict +
                                        id,
                                  ),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            jsonDecode(snapshot.data!.body)["total"].toString(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  color: secondaryColor,
                  child: Center(child: FutureBuilder<http.Response>(
                    future: http.get(
                      place == "station"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalPositiveForStation +
                            id,
                      )
                          : place == "subdivision"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalPositiveForSubdivision +
                            id,
                      )
                          : Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalFeedbackDistrict +
                            id,
                      ),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          jsonDecode(snapshot.data!.body)["total"].toString(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        );
                      }
                    },
                  ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  color: secondaryColor,
                  child: Center(child:
                  FutureBuilder<http.Response>(
                    future: http.get(
                      place == "station"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalNeutralForStation +
                            id,
                      )
                          : place == "subdivision"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalNeutralForSubdivision +
                            id,
                      )
                          : Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalFeedbackDistrict +
                            id,
                      ),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          jsonDecode(snapshot.data!.body)["total"].toString(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        );
                      }
                    },
                  ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.20,
                child: Card(
                  color: secondaryColor,
                  child: Center(child: FutureBuilder<http.Response>(
                    future: http.get(
                      place == "station"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalNegativeForStation +
                            id,
                      )
                          : place == "subdivision"
                          ? Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalNegativeForSubdivision +
                            id,
                      )
                          : Uri.parse(
                        ApiConstants.baseUrl +
                            ApiConstants.chartRoute +
                            time +
                            ApiConstants.totalFeedbackDistrict +
                            id,
                      ),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          jsonDecode(snapshot.data!.body)["total"].toString(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        );
                      }
                    },
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          margin: Responsive.isDesktop(context)
              ? EdgeInsets.only(top: 10, bottom: 10, right: 10)
              : EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          height: Responsive.isDesktop(context)
              ? size.height * 0.25
              : size.height * 0.45,
          child: Card(
            color: secondaryColor,
            child: Center(
              child: FutureBuilder<http.Response>(
                future: http.get(
                  place == "station"
                      ? Uri.parse(
                          ApiConstants.baseUrl +
                              ApiConstants.chartRoute +
                              ApiConstants.averageForStation +
                              id,
                        )
                      : place == "subdivision"
                          ? Uri.parse(
                              ApiConstants.baseUrl +
                                  ApiConstants.chartRoute +
                                  ApiConstants.averageForSubdivision +
                                  id,
                            )
                          : Uri.parse(
                              ApiConstants.baseUrl +
                                  ApiConstants.chartRoute +
                                  ApiConstants.averageForDistrict +
                                  id,
                            ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double average = jsonDecode(snapshot.data!.body)["average"];
                    return Text(
                      average.toString().substring(0, 3),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> getOtherData(Size size) {
    return [
      Expanded(
        child: Card(
          color: secondaryColor,
          child: Center(
            child: FutureBuilder<http.Response>(
              future: http.get(Uri.parse(
                ApiConstants.baseUrl +
                    ApiConstants.chartRoute +
                    time +
                    "/q1/" +
                    id,
              )),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<WeeklyFrequency> frequencyData = [];
                  Map res = jsonDecode(snapshot.data!.body);
                  res.forEach(
                    (key, value) {
                      frequencyData.add(
                          WeeklyFrequency(date: optionsQ1[key]!, count: value));
                    },
                  );

                  return Container(
                    height: size.height * 0.5,
                    child: SafeArea(
                      child: SfCircularChart(
                        series: [
                          DoughnutSeries<WeeklyFrequency, String>(
                            dataSource: frequencyData,
                            xValueMapper: (datum, index) => datum.date,
                            yValueMapper: (datum, index) => datum.count,
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x : point.y',
                        ),
                        title: ChartTitle(
                          text: 'How did people got here ?',
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          alignment: ChartAlignment.center,
                        ),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                          iconWidth: 25,
                          iconHeight: 25,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Card(
          color: secondaryColor,
          child: Center(
            child: FutureBuilder<http.Response>(
              future: http.get(Uri.parse(
                ApiConstants.baseUrl +
                    ApiConstants.chartRoute +
                    time +
                    "/q2/" +
                    id,
              )),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<WeeklyFrequency> frequencyData = [];
                  Map res = jsonDecode(snapshot.data!.body);
                  res.forEach(
                    (key, value) {
                      frequencyData.add(
                          WeeklyFrequency(date: optionsQ2[key]!, count: value));
                    },
                  );

                  return Container(
                    height: size.height * 0.5,
                    child: SafeArea(
                      child: SfCircularChart(
                        series: [
                          DoughnutSeries<WeeklyFrequency, String>(
                            dataSource: frequencyData,
                            xValueMapper: (datum, index) => datum.date,
                            yValueMapper: (datum, index) => datum.count,
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x : point.y',
                        ),
                        title: ChartTitle(
                          text:
                              'After how much time \nthe people were able to get the service?',
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          alignment: ChartAlignment.center,
                        ),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                          iconWidth: 25,
                          iconHeight: 25,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    ];
  }

  getDropdown(Size size) {
    return [
      Text("       Number of feedbacks received     ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),
      Container(
        width:
            Responsive.isDesktop(context) ? size.width * 0.5 : size.width * 0.8,
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
        child: DropdownButton(
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
      ),
    ];
  }
}

class WeeklyFrequency {
  final String date;
  final int count;

  WeeklyFrequency({required this.date, required this.count});
}

class MultiFrequency {
  final String date;
  final int count;
  final String name;

  MultiFrequency({required this.date, required this.count, required this.name});
}

class AverageFrequency {
  final String name;
  final double count;

  AverageFrequency({required this.name, required this.count});
}
