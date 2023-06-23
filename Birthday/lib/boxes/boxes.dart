import 'package:birthday/models/person.dart';
import 'package:hive/hive.dart';

class Boxes
{
  static Box<PersonModel> getData() => Hive.box<PersonModel>("birthday");
}