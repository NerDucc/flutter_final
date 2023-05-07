// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:admin/management/route_names.dart';
import 'package:admin/model/vehicle_model.dart';
import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

List<List<String>> itemList = [];
String filePath = "";


class ManageVehicle extends StatefulWidget {
  const ManageVehicle({super.key});
  @override
  State<ManageVehicle> createState() => _ManageVehicleState();
}

class _ManageVehicleState extends State<ManageVehicle> {

  @override
  void initState() {
    super.initState();
    itemList = [<String>["ID", "Date", "Plate", "RFID", "Status"]];
  }
  final _formKey = GlobalKey<FormState>();
  final fb = FirebaseDatabase.instance.ref("vehicle");
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Manage vehicle');
  late bool autoStatus = true;
  final searchFilter = TextEditingController();
  final dateController = TextEditingController();
  final plateController = TextEditingController();
  final rfidController = TextEditingController();
  final statusController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: autoStatus,
            backgroundColor: Colors.green,
            title: customSearchBar,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      autoStatus = false;
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextField(
                          controller: searchFilter,
                          decoration: InputDecoration(
                            hintText: 'type in vehicle index...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String value) {
                            setState(() {});
                          },
                        ),
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('Manage vehicle');
                      autoStatus = true;
                    }
                  });
                },
                icon: customIcon,
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
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
                          "S-Parking",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text("Manage vehicle"),
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.ManageVehicle);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_parking),
                  title: Text("Manage slots"),
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
          body: StreamBuilder(
              stream: fb.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: const CircularProgressIndicator());
                } else {
                  final listVehicle = Map<dynamic, dynamic>.from(
                      snapshot.data!.snapshot.value as dynamic);
                  List<dynamic> list = [];
                  list.clear();
                  listVehicle.forEach((key, value) {
                    VehicleData data = VehicleData.fromJson(value);
                    VehicleModel myVehicle =
                        VehicleModel(key: key, vehicleData: data);
                    list.add(myVehicle);
                  });
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final plateVehicle =
                            list[index].vehicleData.plate.toString();
                        final dateVehicle =
                            list[index].vehicleData.date.toString();

                        itemList.add(<String>[list[index].key.toString(), 
                        list[index].vehicleData.date.toString(), 
                        list[index].vehicleData.plate.toString(), 
                        list[index].vehicleData.rfid.toString(),
                        list[index].vehicleData.status.toString()
                        ]);
                        if (searchFilter.text.isEmpty) {
                          return InkWell(
                            onTap: () {
                              plateController.text =
                                  list[index].vehicleData.plate.toString();
                              dateController.text =
                                  list[index].vehicleData.date.toString();
                              rfidController.text =
                                  list[index].vehicleData.rfid.toString();
                              statusController.text =
                                  list[index].vehicleData.status.toString();
                              vehicleDialog(list[index]);
                            },
                            child: ListTile(
                                leading: const Icon(Icons.local_parking),
                                trailing: IconButton(
                                    onPressed: () {
                                      _showMyDeleteDialog(list[index]);
                                    },
                                    icon: Icon(Icons.delete)),
                                title: Text(
                                    list[index].vehicleData.plate.toString()),
                                subtitle: Text(
                                    list[index].vehicleData.date.toString())),
                          );
                        } else if (plateVehicle
                            .toLowerCase()
                            .contains(searchFilter.text.toLowerCase())) {
                          return InkWell(
                            onTap: () {
                              plateController.text =
                                  list[index].vehicleData.plate.toString();
                              dateController.text =
                                  list[index].vehicleData.date.toString();
                              rfidController.text =
                                  list[index].vehicleData.rfid.toString();
                              statusController.text =
                                  list[index].vehicleData.status.toString();
                              vehicleDialog(list[index]);
                            },
                            child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      _showMyDeleteDialog(list[index]);
                                    },
                                    icon: Icon(Icons.delete)),
                                leading: const Icon(Icons.local_parking),
                                title: Text(
                                    list[index].vehicleData.plate.toString()),
                                subtitle: Text(
                                    list[index].vehicleData.date.toString())),
                          );
                        } else if (dateVehicle
                            .toLowerCase()
                            .contains(searchFilter.text.toLowerCase())) {
                          return InkWell(
                            onTap: () {
                              plateController.text =
                                  list[index].vehicleData.plate.toString();
                              dateController.text =
                                  list[index].vehicleData.date.toString();
                              rfidController.text =
                                  list[index].vehicleData.rfid.toString();
                              statusController.text =
                                  list[index].vehicleData.status.toString();
                              vehicleDialog(list[index]);
                            },
                            child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      _showMyDeleteDialog(list[index]);
                                      print(list[index].key);
                                    },
                                    icon: Icon(Icons.delete)),
                                leading: const Icon(Icons.local_parking),
                                title: Text(
                                    list[index].vehicleData.plate.toString()),
                                subtitle: Text(
                                    list[index].vehicleData.date.toString())),
                          );
                        } else {
                          return Container();
                        }
                      });
                }
                
              }),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(Icons.file_download),
                onPressed: (){
                generateCSV();
              }),
              ),
    );
  }

  Future<bool?> toast(String message, bool type) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: type == true ? Colors.redAccent : Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  Future<void> _showMyDeleteDialog(VehicleModel slot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Delete data!!'),
            content: SingleChildScrollView(
              child: Column(
                children: const <Widget>[
                  Text('Would you like to delete this data?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  fb.child(slot.key!).remove().then((value) => {
                        Navigator.of(context).pop(),
                        toast("Delete success", true)
                      });
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void vehicleDialog(VehicleModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text("View vehicle"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: plateController,
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Plate value can not be empty';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        hintText: "Plate",
                        prefixIcon: Icon(Icons.car_rental),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dateController,
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Date value can not be empty';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        hintText: "Date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: rfidController,
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'RFID value can not be empty';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        hintText: "RFID",
                        prefixIcon: Icon(Icons.security_rounded),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: statusController,
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Status value can not be empty';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        hintText: "Status",
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: TextButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            Map<String, Object?> slotData = {
                            "Date": dateController.text,
                            "Plate": plateController.text,
                            "RFID": rfidController.text,
                            "Status": statusController.text,
                          };
          
                          fb.child(model.key!).update(slotData).then((value) => {
                                toast("Edit successfully", false),
                                Navigator.of(context).pop()
                              });
                        }},
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.green),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    searchFilter.dispose();
    dateController.dispose();
    plateController.dispose();
    rfidController.dispose();
    statusController.dispose();
    super.dispose();
  }
}

Future<void> send(file, date) async {
    final Email email = Email(
      body: "Your data from the parking system!!",
      subject: "Data exported at $date",
      recipients: ['duc.ngovan225@gmail.com'],
      attachmentPaths: [file],
      isHTML: true,
    );

    String platformResponse = "";

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
  }

generateCSV() async {

  String csvData = ListToCsvConverter().convert(itemList);
  DateTime now = DateTime.now();
  String formatedDate = DateFormat("MM-dd-yyyy-HH-mm-ss").format(now);
  
  Directory generateFile = await getApplicationDocumentsDirectory();
  String appDocPath = generateFile.path;
  final File file = await (File('$appDocPath/data_$formatedDate.csv').create());
  await file.writeAsString(csvData);

  send(file.path, formatedDate);
}
