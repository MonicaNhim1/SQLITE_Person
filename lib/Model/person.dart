class Person {
  late int id;
  late String sex;
  late String name;
  late int age;
  late String pic;
  Person({
    required this.id,
    required this.name,
    required this.sex,
    required this.age,
    required this.pic,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'age': age,
      'pic': pic,
    };
  }

  Person.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sex = res['sex'],
        age = res['age'],
        pic = res['pic'];
}
