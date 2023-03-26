/// id : 7
/// name : "Basement"
/// Total_Slots : 31

class FloorModel {
  FloorModel({
      int? id, 
      String? name, 
      int? totalSlots,}){
    _id = id;
    _name = name;
    _totalSlots = totalSlots;
}

  FloorModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _totalSlots = json['Total_Slots'];
  }
  int? _id;
  String? _name;
  int? _totalSlots;
FloorModel copyWith({  int? id,
  String? name,
  int? totalSlots,
}) => FloorModel(  id: id ?? _id,
  name: name ?? _name,
  totalSlots: totalSlots ?? _totalSlots,
);
  int? get id => _id;
  String? get name => _name;
  int? get totalSlots => _totalSlots;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['Total_Slots'] = _totalSlots;
    return map;
  }

}