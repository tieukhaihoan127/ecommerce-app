class Province {
  
  final String name;
  final String code;

  Province({
    required this.name,
    required this.code,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code:  json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "code": code
    };
  }

}