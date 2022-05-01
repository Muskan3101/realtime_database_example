import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  //reference variable
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Realtime database example"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "name"),
          ),
          TextField(
            controller: idController,
            decoration: InputDecoration(hintText: "id"),
          ),
          ElevatedButton(
              onPressed: () {
                uploadData();
              },
              child: Text("Send to Server")),
          ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text("Fetch Data from Server")),
        ],
      ),
    );
  }

  void uploadData() async {
    var dateTime = DateTime.now().millisecondsSinceEpoch;
    databaseReference
        .child("student/studentinfo/$dateTime")
        .set({"name": nameController.text, "id": idController.text});
  }

  void fetchData() async {
    final snapshot = await databaseReference.child("student/studentinfo").get();

    if (snapshot.exists) {
      print(snapshot.value);
      Fluttertoast.showToast(
          msg: snapshot.value.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    } else {
      Fluttertoast.showToast(
          msg: "No data found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }
  }
}
