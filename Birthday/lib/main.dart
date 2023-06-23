import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:birthday/homePage.dart';
import 'package:birthday/models/person.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  // Database initialisation
  var path = "/assets/db";
  if (!kIsWeb)
  {
    var appDocDir = await getApplicationDocumentsDirectory();
    path = appDocDir.path;
  }
  Hive.init(path);
  Hive.registerAdapter(PersonModelAdapter());
  await Hive.openBox<PersonModel>("birthday");

  // Run App
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: "Birthday App",
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}