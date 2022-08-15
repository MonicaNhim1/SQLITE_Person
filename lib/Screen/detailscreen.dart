import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_person/Model/person.dart';
import 'package:sqlite_person/Screen/second_screen.dart';
import 'package:sqlite_person/connection/database_connetion.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late DatabaseConnection db;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  File? _image;
  late Future<List<Person>> listPerson;
  Future getImagefromCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImagefromGallary() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      listPerson = getList()
          .whenComplete(() => Future.delayed(const Duration(seconds: 1)));
    });
  }

  Future<List<Person>> getList() async {
    return await db.getData();
  }

  @override
  void initState() {
    db = DatabaseConnection();
    _onRefresh();
    db.initializeData().whenComplete(() async {
      setState(() {
        listPerson = db.getData();
        print(listPerson.then((value) => value.first.name.toString()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 250),
      appBar: AppBar(
        title: const Text('Sqlite'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getImagefromCamera();
                });
              },
              icon: const Icon(Icons.camera_alt_outlined)),
          const SizedBox(width: 30),
          IconButton(
              onPressed: () {
                setState(() {
                  getImagefromGallary();
                });
              },
              icon: const Icon(Icons.image)),
          const SizedBox(width: 30),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: _image == null
                            ? const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('asset/image/person.png'))
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(_image!.path)))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
              child: TextFormField(
                controller: namecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: gendercontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your gender'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: TextFormField(
                controller: agecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your age'),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await DatabaseConnection()
                      .insertData(Person(
                          id: Random().nextInt(500),
                          name: namecontroller.text,
                          sex: gendercontroller.text,
                          age: int.parse(agecontroller.text),
                          pic: _image!.path))
                      .whenComplete(() => _onRefresh());
                  namecontroller.text = '';
                  gendercontroller.text = '';
                  agecontroller.text = '';
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              //width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                child: FutureBuilder<List<Person>>(
                    future: listPerson,
                    builder: (context, AsyncSnapshot<List<Person>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Icon(
                            Icons.info,
                            color: Colors.red,
                            size: 30,
                          ),
                        );
                      } else {
                        //final items = snapshot.data ?? <Person>[];
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var per = snapshot.data![index];
                              return InkWell(
                                //============Update=========
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SecondScreen(
                                                person: per,
                                              )));
                                },
                                child: Card(
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              FileImage(File(per.pic)),
                                        ),
                                        title: Text(per.name),
                                        subtitle: Text('Age : ${per.age}'),
                                        trailing: IconButton(
                                            onPressed: () async {
                                              await DatabaseConnection()
                                                  .deleteData(per.id)
                                                  .whenComplete(
                                                      () => _onRefresh());
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )))),
                              );
                            },
                          ),
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => const Icon(Icons.save),
      // )
    );
  }
}
