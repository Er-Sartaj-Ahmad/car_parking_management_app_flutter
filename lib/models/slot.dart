import 'dart:convert';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/slotModel.dart';
import 'package:http/http.dart' as http;

class Slot {
  int? id;
  int free = 1;
  int status = 1;

  setValues(SlotModel slotModel) {
    this.id = slotModel.id;
    this.free = slotModel.free!;
  }

  getSlots(int floorId) async {
    final response = await http.post(Uri.parse(DBHelper().getSlotUrl),
        body: {'Floor_id': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<SlotModel> list = [];
      for (Map i in data) {
        list.add(SlotModel.fromJson(i));
      }
      return list;
    } else {
      return response.body.toString();
    }
  }

  deleteSlot(int id) async {
    final response = await http.post(Uri.parse(DBHelper().deleteSlotUrl),
        body: {'slotId': id.toString()});
    if (response.statusCode == 200) {
      print(response.body);
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }

  addslots(int floorId, int totalSlots) async {
    final response = await http.post(Uri.parse(DBHelper().addSlotsUrl),
        body: {'floorId': floorId.toString(), 'slots': totalSlots.toString()});
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }
}
