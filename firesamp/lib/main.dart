import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseReference databaseReference=FirebaseDatabase.instance.ref();
  TextEditingController dataController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
              child: Column(
                      children: [
                        TextField(
              controller:dataController ,
              decoration: InputDecoration(
                label: Text("Enter Data"),
                border: OutlineInputBorder(
                  
                )
              ),
                        ),
                        ElevatedButton(onPressed: ()async{
              
                        }, child:Text("Input")),
                        ElevatedButton(onPressed: (){
                         
                        }, child: Text("delete"))
                      ],
                    ),
            ),
    );
  }
}