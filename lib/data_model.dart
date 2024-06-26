class UserData {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String? imagepath;

  UserData(
      {this.id,
      required this.name,
      required this.address,
      required this.phone,
      this.imagepath});

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        imagepath: json['imagepath'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'imagepath': imagepath,
    };
  }
}
