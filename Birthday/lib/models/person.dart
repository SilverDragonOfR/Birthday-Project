import 'package:hive_flutter/hive_flutter.dart';
part 'person.g.dart';

@HiveType(typeId: 1)
class PersonModel extends HiveObject
{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime birthDate;
  PersonModel(this.id, this.name, this.birthDate);
}