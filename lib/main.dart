

import 'package:admin/management/home.dart';
import 'package:admin/management/map.dart';
import 'package:admin/management/route_names.dart';
import 'package:admin/management/vehicle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'management/auth/forgot.dart';
import 'management/auth/login.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.Home: (context) => const Home(),
        RouteNames.ManageVehicle: (context) => const ManageVehicle(),
        RouteNames.Map: (context) => const MapPark(),
        RouteNames.Login:(context) => const Login(),
        RouteNames.ForgotPassword:(context) => const ForgotPassword(),
        },
        initialRoute: RouteNames.Login,
    );
     
  }


}