class Model {
  String? id; //doc명 저장
  String name;
  int age;
  List<String>? color;

  Model({required this.name, required this.age, this.color});

// 모델 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'color': color,
    };
  }

// Map에서 Model을 생성하기 위한 팩토리 생성자
  factory Model.formMap(Map<String, dynamic> data) {
    return Model(
      name: data['name'],
      age: data['age'],
      color: List<String>.from(data['color']),
    );
  }
}
