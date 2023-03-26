/// id : 10
/// title : "Hi-ace"
/// charges : 50
/// discount : 50
/// status : 1

class VehicleTypeModel {
  VehicleTypeModel({
      int? id, 
      String? title, 
      int? charges, 
      int? discount, 
      int? status,}){
    _id = id;
    _title = title;
    _charges = charges;
    _discount = discount;
    _status = status;
}

  VehicleTypeModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _charges = json['charges'];
    _discount = json['discount'];
    _status = json['status'];
  }
  int? _id;
  String? _title;
  int? _charges;
  int? _discount;
  int? _status;
VehicleTypeModel copyWith({  int? id,
  String? title,
  int? charges,
  int? discount,
  int? status,
}) => VehicleTypeModel(  id: id ?? _id,
  title: title ?? _title,
  charges: charges ?? _charges,
  discount: discount ?? _discount,
  status: status ?? _status,
);
  int? get id => _id;
  String? get title => _title;
  int? get charges => _charges;
  int? get discount => _discount;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['charges'] = _charges;
    map['discount'] = _discount;
    map['status'] = _status;
    return map;
  }

}