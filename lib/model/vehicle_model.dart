class VehicleModel{
  String? key;
  VehicleData? vehicleData;

  VehicleModel({this.key, this.vehicleData});
}

class VehicleData{
  String? date;
  String? plate;
  String? rfid;
  String? status;

  VehicleData({this.date, this.plate, this.rfid, this.status});

  VehicleData.fromJson(Map<dynamic, dynamic> json){
    date = json["Date"];
    plate = json["Plate"];
    rfid = json["RFID"];
    status = json["Status"];
  }
}