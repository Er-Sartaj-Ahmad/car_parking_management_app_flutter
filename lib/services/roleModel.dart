/// id : 1
/// job_title : "Admin"
/// salary : 1000
/// registration_date : "2022-04-29"
/// Total_Employees : 1

class RoleModel {
  RoleModel({
      int? id, 
      String? jobTitle, 
      int? salary, 
      String? registrationDate, 
      int? totalEmployees,}){
    _id = id;
    _jobTitle = jobTitle;
    _salary = salary;
    _registrationDate = registrationDate;
    _totalEmployees = totalEmployees;
}

  RoleModel.fromJson(dynamic json) {
    _id = json['id'];
    _jobTitle = json['job_title'];
    _salary = json['salary'];
    _registrationDate = json['registration_date'];
    _totalEmployees = json['Total_Employees'];
  }
  int? _id;
  String? _jobTitle;
  int? _salary;
  String? _registrationDate;
  int? _totalEmployees;
RoleModel copyWith({  int? id,
  String? jobTitle,
  int? salary,
  String? registrationDate,
  int? totalEmployees,
}) => RoleModel(  id: id ?? _id,
  jobTitle: jobTitle ?? _jobTitle,
  salary: salary ?? _salary,
  registrationDate: registrationDate ?? _registrationDate,
  totalEmployees: totalEmployees ?? _totalEmployees,
);
  int? get id => _id;
  String? get jobTitle => _jobTitle;
  int? get salary => _salary;
  String? get registrationDate => _registrationDate;
  int? get totalEmployees => _totalEmployees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['job_title'] = _jobTitle;
    map['salary'] = _salary;
    map['registration_date'] = _registrationDate;
    map['Total_Employees'] = _totalEmployees;
    return map;
  }

}