class UserModel {
  int? id;
  String? name;
  String? age;
  String? team;

  UserModel({this.id, this.name, this.age, this.team});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    team = json['team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['team'] = team;
    return data;
  }
}
