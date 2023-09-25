import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskreminder/Components/themes.dart';
import 'package:taskreminder/DataBase/DB_helper.dart';
import 'package:taskreminder/Services/ThemeServices.dart';

import 'Screens/MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // to start Data Base
  await DBHelper.onCreateDataBase();
  // to start Get Storage  when app start
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // to use Getx in any screen
    return GetMaterialApp(
      theme: themes().LightThemes(),
      darkTheme: themes().DarkThemes(),
      themeMode: ThemeService().theme,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
