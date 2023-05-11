import 'package:admin/management/route_names.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/slot_model.dart';
import '../utils/colors.dart';
import '../widget/buildslot.dart';

class MapPark extends StatefulWidget {
  const MapPark({super.key});

  @override
  State<MapPark> createState() => _MapParkState();
}

class _MapParkState extends State<MapPark> {
  late bool autoStatus = true;
  static int numberOfRow = 14;
  final ref = FirebaseDatabase.instance.ref("Sensors");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 181, 228, 169),
        appBar: AppBar(
          automaticallyImplyLeading: autoStatus,
          backgroundColor: Colors.green,
          title: const Text("Map"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage("assets/park.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: const [
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
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Manage vehicle"),
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.ManageVehicle);
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail),
                title: const Text("Manage slots"),
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.Home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text("Map"),
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.Map);
                },
              ),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.Login);
                  },
                )
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Expanded(
                flex: 10,
                child: StreamBuilder(
                    stream: ref.orderByValue().onValue,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        final listSensors = Map<dynamic, dynamic>.from(
                            snapshot.data!.snapshot.value as dynamic);
                        List<dynamic> list1 = [];
                        list1.clear();
                        listSensors.forEach((key, value) {
                          SlotData slot = SlotData.fromJson(value);
                          SlotModel mySlot =
                              SlotModel(key: key, dataSlot: slot);
                          list1.add(mySlot);
                        });
                        list1.sort((a, b) =>
                            a.dataSlot.index.compareTo(b.dataSlot.index));
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: hexStringtoColor("C1AFCB"),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: GridView.builder(
                                itemCount: list1.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: numberOfRow),
                                itemBuilder: (context, index) {
                                  return BuildSlots(
                                      // index: ,
                                      status: list1[index].dataSlot.status,
                                      index: list1[index].dataSlot.index,
                                      );
                                }),
                          ),
                        );
                      }
                    })),
            Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text("Available")
                      ]),
                      Row(children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text("Occupied")
                      ])
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
