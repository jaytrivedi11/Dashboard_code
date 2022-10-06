import 'dart:convert';

import 'package:admin/models/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiConstant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<bool> login(String email, String password) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);

      var body = {
        "email": email,
        "password": password,
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {

        Map res = jsonDecode(response.body);
        prefs.setString("token", res["token"]);
        prefs.setInt("level", res["level"]);
        if(res["level"] == 0){
          prefs.setString("stationID", res['stationID']);

        }
        else if(res["level"] == 1){
          prefs.setString("subdivisionID", res["subdivisionID"]);
        }
        else if (res["level"] == 2){
          prefs.setString("districtID", res['districtID']);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getStationDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stationID = prefs.getString("stationID")!;
    var url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.stationDetails + stationID);

    var res = await http.get(url);
    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);

      prefs.setString("name", response["name"]);
      prefs.setString("address", response["address"]);
      prefs.setString("inspector", response["inspector"]);
      prefs.setString("email", response["email"]);

      return true;
    }
    return false;
  }

  Future<String> getFeedbackByPolicestation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stationID = prefs.getString("stationID")!;
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.feedback + stationID);

    var res = await http.get(url);
    var response = jsonDecode(res.body);
    if (res.statusCode == 200) {
      List<dynamic> list = jsonDecode(res.body);
      FeedbackModel feedback = FeedbackModel.fromJson(list[0]);
      print(feedback.feedback);

      return res.body;
    }
    return res.body;
  }
  Future<String> getFeedbcakDetails(String feedbackid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.feedbackinfo + feedbackid);



    var res = await http.get(url);
    var response = jsonDecode(res.body);
    if(res.statusCode == 200){
      // List<dynamic> list = jsonDecode(res.body);
      // FeedbackModel feedback = FeedbackModel.fromJson(list[0]);
      print(response);


      return res.body;
    }
    return res.body;
  }
}
