class PoliceStationList {
  String? sId;
  String? name;
  String? inspector;

  PoliceStationList({this.sId, this.name,this.inspector});

  PoliceStationList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    inspector = json['inspector'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['inspector'] = this.inspector;
    return data;
  }
}
