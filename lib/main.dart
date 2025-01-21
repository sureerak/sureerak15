import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'showproduct.dart';
import 'showproductgrid.dart';
import 'showproducttype.dart';

// Method หลักที่ Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAlI3OUePTRucvmKA2mASp3Bq18hzR5EEo",
            authDomain: "onlineshopdb-5c273.firebaseapp.com",
            databaseURL:
                "https://onlineshopdb-5c273-default-rtdb.firebaseio.com",
            projectId: "onlineshopdb-5c273",
            storageBucket: "onlineshopdb-5c273.firebasestorage.app",
            messagingSenderId: "463200749193",
            appId: "1:463200749193:web:f6cda03859fd6311dee858",
            measurementId: "G-54QJNY2CQS"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลบนจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 221, 245, 134)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

// Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าหลัก'),
        backgroundColor: const Color.fromARGB(255, 230, 144, 245),
      ),
      body: Center(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // โลโก้
          SizedBox(height: 20), // เพิ่มระยะห่างจากแท็บบาร์
          Image.asset(
            'assets/logo20.png',
            width: 200,
            height: 200, // ลดขนาดโลโก้เพื่อให้มีสมดุลกับปุ่ม
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10), // เว้นระยะระหว่างโลโก้และปุ่ม
          // ปุ่มที่ 1
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addproduct(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: const Color.fromARGB(255, 230, 144, 245),
            ),
            child: Text(
              'บันทึกข้อมูลสินค้า',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          // ปุ่มที่ 2
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => showproductgrid(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: const Color.fromARGB(255, 230, 144, 245),
            ),
            child: Text(
              'แสดงข้อมูลสินค้า',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          // ปุ่มที่ 3
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowProductType(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: const Color.fromARGB(255, 230, 144, 245),
            ),
            child: Text(
              'ประเภทสินค้า',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ),
  ),
),

    );
  }
}
