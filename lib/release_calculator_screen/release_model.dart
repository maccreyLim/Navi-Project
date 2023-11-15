import 'package:cloud_firestore/cloud_firestore.dart';

class ReleaseModel {
  String? id;
  String name;
  DateTime inputDate;
  int years;
  int months;

  // Constructor
  ReleaseModel({
    this.id,
    required this.name,
    required this.inputDate,
    required this.years,
    required this.months,
  });

  // 모델 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inputDate': inputDate,
      'years': years,
      'months': months,
    };
  }

  // Map에서 Model을 생성하기 위한 팩토리 생성자
  factory ReleaseModel.fromMap(Map<String, dynamic> data) {
    return ReleaseModel(
      id: data['id'],
      name: data['name'],
      inputDate: (data['inputDate'] as Timestamp).toDate(),
      years: data['years'],
      months: data['months'],
    );
  }
}
