import 'package:crm_center_admin_charts/screen/home/home_page.dart';
import 'package:crm_center_admin_charts/screen/login/login_page.dart';
import 'package:crm_center_admin_charts/screen/login/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await GetStorage.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRM ATKO',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white,size: 30.0),
          titleTextStyle: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.w700)
        ),
        scaffoldBackgroundColor: Color(0xffF9F9F9),
      ),
      home: SplashPage(),
    );
  }
}
