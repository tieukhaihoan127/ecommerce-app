class District {
  
  final String name;
  final String code;

  District({
    required this.name,
    required this.code,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name_with_type'],
      code:  json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name_with_type": name,
      "code": code
    };
  }

}