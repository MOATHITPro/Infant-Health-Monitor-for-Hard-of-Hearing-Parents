// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wear_os3/Connecting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseReference _babyStatusRef; // مرجع قاعدة البيانات في Firebase
  String displayedText = 'Everything is fine\nMom'; // النص الافتراضي

  @override
  void initState() {
    super.initState();

    // الاتصال بقاعدة البيانات عبر Firebase
    _babyStatusRef = FirebaseDatabase.instance.ref('baby_status/crying');

    // الاستماع لتحديثات النص
    _babyStatusRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        setState(() {
          displayedText = event.snapshot.value.toString(); // تحديث النص
        });

        // تفعيل الاهتزاز عند التحديث
        _triggerVibration();

        // حذف الرسالة من Firebase بعد التحديث
        _deleteMessage();
      }
    });
  }

  // تفعيل الاهتزاز عند التحديث
  void _triggerVibration() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 6000); // اهتزاز لمدة 6 ثوانٍ
    }
  }

  // حذف الرسالة من Firebase بعد الاهتزاز
  void _deleteMessage() {
    _babyStatusRef.remove(); // حذف الرسالة من قاعدة البيانات
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double textSize = screenWidth < 400 ? 14 : 18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My baby voice',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 25, 135, 56)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 192, 223, 156),
      ),
      backgroundColor: const Color(0xFFEEF6DE),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20), // مسافة لتحسين التنسيق
              // النص الذي يتم تحديثه من Firebase
              Text(
                displayedText.split('\n').first, // عرض السطر الأول
                style: TextStyle(
                  fontSize: 20 * textScaleFactor,
                  color: const Color.fromARGB(255, 23, 131, 53),
                ),
              ),
              Text(
                displayedText.split('\n').length > 1
                    ? displayedText.split('\n').last
                    : '', // عرض السطر الثاني إن وجد
                style: TextStyle(
                  fontSize: 20 * textScaleFactor,
                  color: const Color.fromARGB(255, 23, 131, 53),
                ),
              ),
              const Spacer(), // دفع الزر إلى الأسفل
              // زر "Setting"
              Container(
                width: 100, // عرض الزر
                height: 40, // ارتفاع الزر
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 192, 223, 156),
                  borderRadius: BorderRadius.circular(8), // زوايا مستديرة
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Connecting()),
                    ); // الانتقال إلى الصفحة التالية عند النقر
                  },
                  child: const Text(
                    'Setting',
                    style: TextStyle(
                      color: Color.fromARGB(255, 131, 131, 131), // لون النص
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // مسافة لتحسين التنسيق
            ],
          ),
        ),
      ),
    );
  }
}
