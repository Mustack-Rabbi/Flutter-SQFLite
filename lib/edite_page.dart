import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data_model.dart';
import 'package:flutter_sqflite/database/db_helper.dart';
import 'package:flutter_sqflite/home_page.dart';
import 'package:image_picker/image_picker.dart';


// ignore: must_be_immutable
class EditePage extends StatefulWidget {
  EditePage(
      {super.key,
      required this.title,
      required this.name,
      required this.enterName,
      required this.address,
      required this.enterAddress,
      required this.phone,
      required this.enterPhone,
      this.initialControllerName,
      this.initialControllerAddres,
      this.initialControllerPhone,
      this.dbId,
      this.dbImage});
  final String title;
  final String name;
  final String enterName;
  final String address;
  final String enterAddress;
  final String phone;
  final String enterPhone;
  final String? initialControllerName;
  final String? initialControllerAddres;
  final String? initialControllerPhone;
  final int? dbId;
  final String? dbImage;

  @override
  State<EditePage> createState() => _EditePageState();
}

class _EditePageState extends State<EditePage> {
  File? imagepath;


  @override
  Widget build(BuildContext context) {
    final textControllerText =
        TextEditingController(text: widget.initialControllerName);
    final textControllerAddress =
        TextEditingController(text: widget.initialControllerAddres);
    final textControllerPhone =
        TextEditingController(text: widget.initialControllerPhone);
    File myDBFile = File(widget.dbImage.toString());
    var widgetDBImageTxt = widget.dbImage.toString();
  //  print("ttrow =========> $ttrow");

    String prefixPhoneNumber = "+880 ";
    //String imagFilePath = imagepath!.path.toString();

    // File dImage =  dbImage;

    fileImg() {
      if (imagepath != null) {
        return Expanded(child: Image.file(imagepath!.absolute));
      } else if (widgetDBImageTxt != "null") {
        return Expanded(child: Image.file(myDBFile.absolute));
      } else {
        return Text("No Image Add");
      }
    }


    imgPath() {
      if (imagepath == null) {
        return "null";
      } else {
        return imagepath!.path.toString();
      }
    }

    imgDbPath() {
      if (imagepath != null) {
        return imagepath!.path.toString();
      } else {
        return widgetDBImageTxt;
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: textControllerText,
              onChanged: (value) {
                //   setState(() {
                //  textFieldName = value;
                //   });

                // setState(() {
                //   value1 = value;
                // });
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: widget.name,
                hintText: widget.enterName,
                suffixIcon: IconButton(
                  onPressed: () {
                    textControllerText.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: textControllerAddress,
              onChanged: (value) {
                //  setState(() {});
              },
              decoration: InputDecoration(
                suffix: CircleAvatar(
                  child: Icon(Icons.accessibility_sharp),
                ),
                border: const OutlineInputBorder(),
                labelText: widget.address,
                hintText: widget.enterAddress,
                suffixIcon: IconButton(
                  onPressed: () {
                    textControllerAddress.clear();
                    // setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            TextField(
              keyboardType: TextInputType.number,
              controller: textControllerPhone,
              onChanged: (value) {
                //  setState(() {
                //    = value
                //  });
              },
              decoration: InputDecoration(
                prefixText: prefixPhoneNumber,
                border: const OutlineInputBorder(),
                labelText: (prefixPhoneNumber + widget.phone),
                hintText: widget.enterPhone,
                suffixIcon: IconButton(
                  onPressed: () {
                    textControllerPhone.clear();
                    //  setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),

           
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0), child: fileImg()

          
                    )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        pickImgGallery();
                      },
                      child: Icon(Icons.photo_library),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                  ],
                ),
                MaterialButton(
                  color: Colors.amberAccent,
                  child: Text("Save"),
                  onPressed: () async {
                    if (widget.dbId != null) {
                      DatabaseHelper.instance.update(
                        UserData(
                            id: widget.dbId,
                            name: textControllerText.text,
                            address: textControllerAddress.text,
                            phone: textControllerPhone.text,
                            imagepath: imgDbPath().toString()),
                      );

                      setState(() async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false);
                        // widget.dbId=null;
                      });
                    }

                    DatabaseHelper.instance.add(
                      UserData(
                        name: textControllerText.text,
                        address: textControllerAddress.text,
                        phone: prefixPhoneNumber + textControllerPhone.text,

                        //////////////////////
                        ///if (imagepath!.path.toString() == null) {
                        ///      }
                        //  imagepath: imagepath!.path.toString(),
                        imagepath: imgPath().toString(),
                        // imagepath: imagepath
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pickImgGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imagepath = File(pickedImage!.path);

    setState(() {
      imagepath = imagepath;

    });
  }
}
