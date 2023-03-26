/// id : 69
/// charges : 40
/// discount : 50
/// VehicleType_id : 25
/// vehicleTypeName : "Car"
/// Slot_id : 606
/// Floor_id : 39
/// VehicleNo : 901
/// vehicle_name : "Sonata"
/// vehicle_model : 2022
/// owner_name : "Bot"

class ParkingModel {
  ParkingModel({
      int? id, 
      int? charges, 
      int? discount, 
      int? vehicleTypeId, 
      String? vehicleTypeName, 
      int? slotId, 
      int? floorId, 
      int? vehicleNo, 
      String? vehicleName, 
      int? vehicleModel, 
      String? ownerName,}){
    _id = id;
    _charges = charges;
    _discount = discount;
    _vehicleTypeId = vehicleTypeId;
    _vehicleTypeName = vehicleTypeName;
    _slotId = slotId;
    _floorId = floorId;
    _vehicleNo = vehicleNo;
    _vehicleName = vehicleName;
    _vehicleModel = vehicleModel;
    _ownerName = ownerName;
}

  ParkingModel.fromJson(dynamic json) {
    _id = json['id'];
    _charges = json['charges'];
    _discount = json['discount'];
    _vehicleTypeId = json['VehicleType_id'];
    _vehicleTypeName = json['vehicleTypeName'];
    _slotId = json['Slot_id'];
    _floorId = json['Floor_id'];
    _vehicleNo = json['VehicleNo'];
    _vehicleName = json['vehicle_name'];
    _vehicleModel = json['vehicle_model'];
    _ownerName = json['owner_name'];
  }
  int? _id;
  int? _charges;
  int? _discount;
  int? _vehicleTypeId;
  String? _vehicleTypeName;
  int? _slotId;
  int? _floorId;
  int? _vehicleNo;
  String? _vehicleName;
  int? _vehicleModel;
  String? _ownerName;
ParkingModel copyWith({  int? id,
  int? charges,
  int? discount,
  int? vehicleTypeId,
  String? vehicleTypeName,
  int? slotId,
  int? floorId,
  int? vehicleNo,
  String? vehicleName,
  int? vehicleModel,
  String? ownerName,
}) => ParkingModel(  id: id ?? _id,
  charges: charges ?? _charges,
  discount: discount ?? _discount,
  vehicleTypeId: vehicleTypeId ?? _vehicleTypeId,
  vehicleTypeName: vehicleTypeName ?? _vehicleTypeName,
  slotId: slotId ?? _slotId,
  floorId: floorId ?? _floorId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  vehicleName: vehicleName ?? _vehicleName,
  vehicleModel: vehicleModel ?? _vehicleModel,
  ownerName: ownerName ?? _ownerName,
);
  int? get id => _id;
  int? get charges => _charges;
  int? get discount => _discount;
  int? get vehicleTypeId => _vehicleTypeId;
  String? get vehicleTypeName => _vehicleTypeName;
  int? get slotId => _slotId;
  int? get floorId => _floorId;
  int? get vehicleNo => _vehicleNo;
  String? get vehicleName => _vehicleName;
  int? get vehicleModel => _vehicleModel;
  String? get ownerName => _ownerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['charges'] = _charges;
    map['discount'] = _discount;
    map['VehicleType_id'] = _vehicleTypeId;
    map['vehicleTypeName'] = _vehicleTypeName;
    map['Slot_id'] = _slotId;
    map['Floor_id'] = _floorId;
    map['VehicleNo'] = _vehicleNo;
    map['vehicle_name'] = _vehicleName;
    map['vehicle_model'] = _vehicleModel;
    map['owner_name'] = _ownerName;
    return map;
  }

}