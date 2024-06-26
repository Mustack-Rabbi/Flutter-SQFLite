import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data_model.dart';
import 'package:flutter_sqflite/database/db_helper.dart';
import 'package:flutter_sqflite/edite_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper? databaseHelper;

  late Future<List<UserData>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    notesList = databaseHelper!.getSqfliteuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFlite User Data"),
      ),
      body: Center(
        child: FutureBuilder<List<UserData>>(
            future: DatabaseHelper.instance.getSqfliteuser(),
            builder:
                (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No User in List.'))
                  : ListView(
                      children: snapshot.data!.map((sqfliteTwoUser) {
                        var myFile = File("${sqfliteTwoUser.imagepath}");
                        String imgPathText = "${sqfliteTwoUser.imagepath}";

                        imgView() {
                          if (imgPathText == "null") {
                            return Center(child: Text("[No Image]"));
                          } else {
                            return Center(
                              child: Container(
                                color: Colors.brown[100],
                                child: SizedBox(
                                  height: 100,
                                  width: 200,
                                  // child: Image.file(myFile.absolute),
                                  child: Image.file(myFile.absolute),
                                ),
                              ),
                            );
                          }
                        }

                    
                        return Center(
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name   : ${sqfliteTwoUser.name}"),
                                Text("Adress : ${sqfliteTwoUser.address}"),
                                Text("Number : ${sqfliteTwoUser.phone}"),
                         
                                imgView(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Want Delete?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            DatabaseHelper
                                                                .instance
                                                                .remove(
                                                                    sqfliteTwoUser
                                                                        .id!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        child: Text("Delete")),
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        child: Text("Cancle")),
                                                  ],
                                                );
                                              });
                                        },
                                        child: const Text("Delete")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditePage(
                                                        title:
                                                            "Edite Your Data",
                                                        name: "Edite your Name",
                                                        enterName:
                                                            "${sqfliteTwoUser.name}",
                                                        address:
                                                            "Edit Your Address",
                                                        enterAddress:
                                                            "${sqfliteTwoUser.address}",
                                                        phone:
                                                            "Edit Your Phone",
                                                        enterPhone:
                                                            "${sqfliteTwoUser.phone}",
                                                        initialControllerName:
                                                            "${sqfliteTwoUser.name}",
                                                        initialControllerAddres:
                                                            "${sqfliteTwoUser.address}",
                                                        initialControllerPhone:
                                                            "${sqfliteTwoUser.phone}",
                                                        dbId: sqfliteTwoUser.id!
                                                            .toInt(),
                                                        dbImage: myFile.path,
                                                      )));

                                          //     setState(() {

                                          //  });
                                        },
                                        child: const Text("Edit")),
                                  ],
                                )
                              ],
                            ),
                          )),
                        );
                      }).toList(),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditePage(
                        title: "Add Your New Data",
                        name: "Add Your Name",
                        enterName: "Enter Add Your Name",
                        address: "Add Your Adress",
                        enterAddress: "Enter Your Adress",
                        phone: "Add Your Phone",
                        enterPhone: "Enter Add Your Phone",
                        dbId: null,
                        //   dbImage: null,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
