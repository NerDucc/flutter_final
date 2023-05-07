import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widget/reuse.dart';
import '../route_names.dart';

 
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.lightGreenAccent,Colors.white,Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            )
          ),
          child: SingleChildScrollView(
            child:  Padding(
              padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    const Icon(
                      Icons.lock,
                      size: 120,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Welcome to the S-Parking management system",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email" ,Icons.person, false, _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password",Icons.lock, true, _passwordController),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ForgotPassword()
                     ),
                    
                    signInSignUpButton(context, "Sign In", (){
                      try{
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim())
                      .then((value) {
                          Navigator.pushNamed(context, RouteNames.Home);
                      });
                      }on FirebaseAuthException catch(e){
                          ElegantNotification.error(
                              title:  const Text("Error"),
                              description:  Text(e.message.toString())
                            ).show(context);
                      }
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],  
                ),
              )),
          ),
        ),
    )
    );
  }
  Row ForgotPassword(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteNames.ForgotPassword);
        },
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      )
                      ],);
  }

  
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
}