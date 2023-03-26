/// membershipCode : 3127
/// VehicleType_id : 25
/// vehicleNo : "901"
/// vehicle_name : "Grandi"
/// vehicle_model : 2022
/// owner_name : "Asad"

class VehicleModel {
  VehicleModel({
      int? membershipCode, 
      int? vehicleTypeId, 
      String? vehicleNo, 
      String? vehicleName, 
      int? vehicleModel, 
      String? ownerName,}){
    _membershipCode = membershipCode;
    _vehicleTypeId = vehicleTypeId;
    _vehicleNo = vehicleNo;
    _vehicleName = vehicleName;
    _vehicleModel = vehicleModel;
    _ownerName = ownerName;
}

  VehicleModel.fromJson(dynamic json) {
    _membershipCode = json['membershipCode'];
    _vehicleTypeId = json['VehicleType_id'];
    _vehicleNo = json['vehicleNo'];
    _vehicleName = json['vehicle_name'];
    _vehicleModel = json['vehicle_model'];
    _ownerName = json['owner_name'];
  }
  int? _membershipCode;
  int? _vehicleTypeId;
  String? _vehicleNo;
  String? _vehicleName;
  int? _vehicleModel;
  String? _ownerName;
VehicleModel copyWith({  int? membershipCode,
  int? vehicleTypeId,
  String? vehicleNo,
  String? vehicleName,
  int? vehicleModel,
  String? ownerName,
}) => VehicleModel(  membershipCode: membershipCode ?? _membershipCode,
  vehicleTypeId: vehicleTypeId ?? _vehicleTypeId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  vehicleName: vehicleName ?? _vehicleName,
  vehicleModel: vehicleModel ?? _vehicleModel,
  ownerName: ownerName ?? _ownerName,
);
  int? get membershipCode => _membershipCode;
  int? get vehicleTypeId => _vehicleTypeId;
  String? get vehicleNo => _vehicleNo;
  String? get vehicleName => _vehicleName;
  int? get vehicleModel => _vehicleModel;
  String? get ownerName => _ownerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['membershipCode'] = _membershipCode;
    map['VehicleType_id'] = _vehicleTypeId;
    map['vehicleNo'] = _vehicleNo;
    map['vehicle_name'] = _vehicleName;
    map['vehicle_model'] = _vehicleModel;
    map['owner_name'] = _ownerName;
    return map;
  }

}