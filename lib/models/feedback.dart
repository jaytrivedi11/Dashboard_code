class FeedbackModel {
  String? sId;
  String? policestationID;
  String? subdivisionID;
  String? districtID;
  String? name;
  String? mobile;
  int? q1;
  int? q2;
  int? stars;
  String? feedback;
  String? date;
  int? iV;
  String? sentiment;

  FeedbackModel(
      {this.sId,
        this.policestationID,
        this.subdivisionID,
        this.districtID,
        this.name,
        this.mobile,
        this.q1,
        this.q2,
        this.stars,
        this.feedback,
        this.date,
        this.iV,
        this.sentiment,
      });

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    policestationID = json['policestationID'];
    subdivisionID = json['subdivisionID'];
    districtID = json['districtID'];
    name = json['name'];
    mobile = json['mobile'];
    q1 = json['q1'];
    q2 = json['q2'];
    stars = json['stars'];
    feedback = json['feedback'];
    date = json['date'];
    iV = json['__v'];
    sentiment = json["sentiment"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['policestationID'] = this.policestationID;
    data['subdivisionID'] = this.subdivisionID;
    data['districtID'] = this.districtID;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['q1'] = this.q1;
    data['q2'] = this.q2;
    data['stars'] = this.stars;
    data['feedback'] = this.feedback;
    data['date'] = this.date;
    data['__v'] = this.iV;
    data["sentiment"] = this.sentiment;
    return data;
  }
}
