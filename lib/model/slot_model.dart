class SlotModel{
  String? key;
  SlotData? dataSlot;

  SlotModel({this.key, this.dataSlot});
}

class SlotData{
  int? index;
  int? status;

  SlotData({this.index, this.status});

  SlotData.fromJson(Map<dynamic, dynamic> json){
    index = json["index"];
    status = json["status"];
  }
}