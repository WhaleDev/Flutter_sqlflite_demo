class User {
  User();

  int _id;
  String _name;
  String _desc;

  int get id => _id;

  String get name => _name;

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;

    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._desc = map['desc'];
  }
}
