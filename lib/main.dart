import 'package:flutter/material.dart';
import 'package:leez/screens/ret/rent_navbar.dart';
import 'package:leez/screens/user/home/navbar.dart';
import 'package:provider/provider.dart';
import 'package:leez/providers/property_provider.dart';




void main() {
  runApp(
    MultiProvider(
      providers: [
        // This must wrap HomeScreen so that HomeScreen can find PropertyProvider
        ChangeNotifierProvider(
          create: (_) => PropertyProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leez A Rental Platform',
      home: const NavBar(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}




















