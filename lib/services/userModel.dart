/// id : 1
/// name : "Sartaj Ahmad"
/// contact : "03467715568"
/// registration_date : "2022-04-29"
/// DOB : "2000-01-01"
/// job_title : "Admin"
/// salary : 1000
/// username : "SartajAhmad"
/// password : "3123"

class UserModel {
  UserModel({
    int? id,
    String? name,
    String? contact,
    String? registrationDate,
    String? dob,
    String? jobTitle,
    int? salary,
    String? username,
    String? password,}){
    _id = id;
    _name = name;
    _contact = contact;
    _registrationDate = registrationDate;
    _dob = dob;
    _jobTitle = jobTitle;
    _salary = salary;
    _username = username;
    _password = password;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _contact = json['contact'];
    _registrationDate = json['registration_date'];
    _dob = json['DOB'];
    _jobTitle = json['job_title'];
    _salary = json['salary'];
    _username = json['username'];
    _password = json['password'];
  }
  int? _id;
  String? _name;
  String? _contact;
  String? _registrationDate;
  String? _dob;
  String? _jobTitle;
  int? _salary;
  String? _username;
  String? _password;
  UserModel copyWith({  int? id,
    String? name,
    String? contact,
    String? registrationDate,
    String? dob,
    String? jobTitle,
    int? salary,
    String? username,
    String? password,
  }) => UserModel(  id: id ?? _id,
    name: name ?? _name,
    contact: contact ?? _contact,
    registrationDate: registrationDate ?? _registrationDate,
    dob: dob ?? _dob,
    jobTitle: jobTitle ?? _jobTitle,
    salary: salary ?? _salary,
    username: username ?? _username,
    password: password ?? _password,
  );
  int? get id => _id;
  String? get name => _name;
  String? get contact => _contact;
  String? get registrationDate => _registrationDate;
  String? get dob => _dob;
  String? get jobTitle => _jobTitle;
  int? get salary => _salary;
  String? get username => _username;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['contact'] = _contact;
    map['registration_date'] = _registrationDate;
    map['DOB'] = _dob;
    map['job_title'] = _jobTitle;
    map['salary'] = _salary;
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

}