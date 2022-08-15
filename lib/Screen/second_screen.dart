import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqlite_person/Model/person.dart';
import 'package:sqlite_person/Screen/detailscreen.dart';

import '../connection/database_connetion.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({required this.person, Key? key}) : super(key: key);
  Person person;
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController upNamecontroller = TextEditingController();
  TextEditingController upGendercontroller = TextEditingController();
  TextEditingController upAgecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upNamecontroller.text = widget.person.name;
    upGendercontroller.text = widget.person.sex;
    upAgecontroller.text = widget.person.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'U P D A T E S C R E E N',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                      image: widget.person.pic == null
                          ? const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/person.png'),
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(widget.person.pic))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              child: TextField(
                controller: upNamecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: upGendercontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: upAgecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await DatabaseConnection()
                      .updateData(Person(
                          id: widget.person.id,
                          name: upNamecontroller.text,
                          sex: upGendercontroller.text,
                          age: int.parse(upAgecontroller.text),
                          pic: widget.person.pic))
                      .whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(),
                          ),
                          (route) => false));
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent),
                )),
          ],
        ),
      ),
    );
  }
}
