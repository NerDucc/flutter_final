import 'dart:js';

import 'package:flutter/material.dart';

import '../management/route_names.dart';
Drawer nav(){
  return Drawer(
    child: ListView(
            children: [
              DrawerHeader(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 8.0,
                      left: 4.0,
                      child: Text(
                        "App Making.co",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage("assets/park.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text("About"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text("Contact"),
                onTap: () {},
              )
            ],
          )
  );
}
            