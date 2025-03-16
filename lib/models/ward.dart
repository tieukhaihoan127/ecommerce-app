class Ward {
  
  final String name;
  final String code;

  Ward({
    required this.name,
    required this.code,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
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