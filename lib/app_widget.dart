import 'package:flutter/material.dart';
import 'home_page/home_page.dart';

class AppWidget extends StatelessWidget{
  final String title;

  const AppWidget({super.key, required this.title});



  @override
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData.light(),
        home: const HomePage()
    );
  }
}