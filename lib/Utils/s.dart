/// Name : "Rehan"

class S {
  S({
    String? name,
  }) {
    _name = name;
  }

  S.fromJson(dynamic json) {
    _name = json['Name'];
  }

  String? _name;

  S copyWith({
    String? name,
  }) =>
      S(
        name: name ?? _name,
      );

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    return map;
  }
}
