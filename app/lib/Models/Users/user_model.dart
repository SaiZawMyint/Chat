import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.gender  = '',
    this.bio = '',
    this.dob
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String bio;
  final DateTime? dob;
  final String gender;


  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? bio,
    String? gender,
    DateTime? dob
  }) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        bio: bio ?? this.bio,
        gender: gender ?? this.gender,
        dob: dob ?? this.dob
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    DateTime dob = DateTime.now();
    if(json["dob"]!=null) {
      final d = json["dob"] as Timestamp;
      dob = d.toDate();
    }
    return UserModel(
      name: json["name"],
      email: json["email"],
      bio: json["bio"],
      gender: json["gender"],
      dob: dob
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "email": email,
      "bio": bio,
      "gender": gender,
      "dob": Timestamp.fromDate(dob??DateTime.now())
    };
  }

}
