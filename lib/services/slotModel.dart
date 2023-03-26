/// id : 494
/// Floor_id : 31
/// free : 1
/// status : 1

class SlotModel {
  SlotModel({
      int? id, 
      int? floorId, 
      int? free, 
      int? status,}){
    _id = id;
    _floorId = floorId;
    _free = free;
    _status = status;
}

  SlotModel.fromJson(dynamic json) {
    _id = json['id'];
    _floorId = json['Floor_id'];
    _free = json['free'];
    _status = json['status'];
  }
  int? _id;
  int? _floorId;
  int? _free;
  int? _status;
SlotModel copyWith({  int? id,
  int? floorId,
  int? free,
  int? status,
}) => SlotModel(  id: id ?? _id,
  floorId: floorId ?? _floorId,
  free: free ?? _free,
  status: status ?? _status,
);
  int? get id => _id;
  int? get floorId => _floorId;
  int? get free => _free;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Floor_id'] = _floorId;
    map['free'] = _free;
    map['status'] = _status;
    return map;
  }

}