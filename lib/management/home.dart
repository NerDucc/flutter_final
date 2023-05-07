// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'package:admin/management/route_names.dart';
import 'package:admin/model/slot_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownStatus = statusList[0];
  }

  final _formKey = GlobalKey<FormState>();

  final ref = FirebaseDatabase.instance.ref("Sensors");
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Manage slots');
  final searchFilter = TextEditingController();
  final indexTextController = TextEditingController();
  final statusTextController = TextEditingController();
  late bool autoStatus = true;
  bool updateSlot = false;
  int? dropdownStatus;
  late String filter_toast = "";

  // List of items in our dropdown menu
  final statusList = [
    2,
    1,
    0,
  ];

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
                  customIcon = Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: DropdownButton(
                      value: dropdownStatus,
                      icon: const Icon(Icons.filter_list_sharp),
                      items: statusList.map((dropdownStatus) {
                        return DropdownMenuItem(
                          value: dropdownStatus,
                          child: dropdownStatus == 0
                              ? Text("Index")
                              : dropdownStatus == 1
                                  ? Text("Status")
                                  : Text("Filter"),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownStatus = newValue;
                        });
                      },
                    ),
                    title: TextField(
                        controller: searchFilter,
                        decoration: InputDecoration(
                          hintText: 'type in slot data...',
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
                        }),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Manage slots');
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
                      "App Making.co",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Manage vehicle"),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.ManageVehicle);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
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
          stream: ref.orderByValue().onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const CircularProgressIndicator());
            } else {
              final listSensors = Map<dynamic, dynamic>.from(
                  snapshot.data!.snapshot.value as dynamic);
              List<dynamic> list1 = [];
              list1.clear();
              listSensors.forEach((key, value) {
                SlotData slot = SlotData.fromJson(value);
                SlotModel mySlot = SlotModel(key: key, dataSlot: slot);
                list1.add(mySlot);
              });
              list1
                  .sort((a, b) => a.dataSlot.index.compareTo(b.dataSlot.index));
              return ListView.builder(
                  itemCount: list1.length,
                  itemBuilder: (context, index) {
                    final indexSlot = list1[index].dataSlot.index.toString();
                    final statusSlot = list1[index].dataSlot.status.toString();

                    if (dropdownStatus == 2) {
                      if (searchFilter.text.isEmpty) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else if (indexSlot
                          .toLowerCase()
                          .contains(searchFilter.text.toLowerCase())) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else if (statusSlot
                          .toLowerCase()
                          .contains(dropdownStatus.toString())) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else if (dropdownStatus == 1) {
                      if (searchFilter.text.isEmpty) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else if (statusSlot
                          .toLowerCase()
                          .contains(searchFilter.text.toString())) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else if (dropdownStatus == 0) {
                      if (searchFilter.text.isEmpty) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else if (indexSlot
                          .toLowerCase()
                          .contains(searchFilter.text.toLowerCase())) {
                        return InkWell(
                          onTap: () {
                            indexTextController.text =
                                list1[index].dataSlot.index.toString();
                            statusTextController.text =
                                list1[index].dataSlot.status.toString();
                            updateSlot = true;
                            slotDialog(list1[index].key);
                          },
                          child: ListTile(
                            trailing: Icon(Icons.sensor_occupied),
                            title: Text(list1[index].dataSlot.index.toString()),
                            subtitle: list1[index].dataSlot.status == 1
                                ? Text("Available")
                                : list1[index].dataSlot.status == 2
                                    ? Text("Occupied")
                                    : Text("Not Using"),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          indexTextController.text = "";
          statusTextController.text = "";
          updateSlot = false;
          slotDialog("");
        },
        child: const Icon(Icons.add),
      ),
    ));
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

  void slotDialog(String? key) {
    showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text(updateSlot ? "Edit slot" : "Add new slot"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: indexTextController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Index value can not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        label: Text("Index"),
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: statusTextController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Status value can not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-3]')),
                      ],
                      decoration: InputDecoration(
                        label: Text("Status"),
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        prefixIcon: Icon(Icons.stadium),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: TextButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            Map<String, Object?> slotData = {
                            "index": int.parse(indexTextController.text),
                            "status": int.parse(statusTextController.text),
                          };
                          if (updateSlot == true) {
                            ref.child(key!).update(slotData).then((value) => {
                                  toast("Insert successfully", false),
                                  Navigator.of(context).pop()
                                });
                          } else {
                            ref.push().set(slotData).then((value) {
                              toast("Update successfully", false);
                              Navigator.of(context).pop();
                            });
                          }}
                        },
                        child: Text(
                          updateSlot ? "Edit" : "Submit",
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
    indexTextController.dispose();
    statusTextController.dispose();
    super.dispose();
  }
}
