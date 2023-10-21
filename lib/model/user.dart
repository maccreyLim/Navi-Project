class UserModel {
  final String email;
  final String mobilePhone;
  final String nickName;
  final String uid;
  final int visitCount;
  final bool emailVerified;
  final bool admin;
  final bool partners;
  final String? photoUrl;

  UserModel({
    required this.email,
    required this.mobilePhone,
    required this.nickName,
    required this.uid,
    required this.visitCount,
    required this.emailVerified,
    required this.admin,
    required this.partners,
    required this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      mobilePhone: json['mobilePhone'] as String,
      nickName: json['nickName'] as String,
      uid: json['uid'] as String,
      visitCount: json['visitCount'] as int,
      emailVerified: json['emailVerified'] as bool,
      admin: json['emailVerified'] as bool,
      partners: json['emailVerified'] as bool,
      photoUrl: json['nickName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobilePhone': mobilePhone,
      'nickName': nickName,
      'uid': uid,
      'visitCount': visitCount,
      'emailVerified': emailVerified,
      'admin': false,
      'parters': false,
      'photoUrl': photoUrl,
    };
  }
}
