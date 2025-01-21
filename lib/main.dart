// ignore_for_file: unused_import
// هذه التعليمة لإخفاء تحذير الاستخدام غير المستخدم للاستيرادات في الكود

import 'package:flutter/material.dart'; // استيراد مكتبة Flutter لبناء واجهة المستخدم
import 'package:wear_os3/Home.dart'; // استيراد الشاشة الرئيسية (Home) من ملف Home.dart
import 'package:firebase_core/firebase_core.dart'; // استيراد مكتبة تهيئة Firebase
import 'package:firebase_database/firebase_database.dart'; // استيراد مكتبة Firebase Database للتفاعل مع قاعدة البيانات
import 'package:vibration/vibration.dart'; // استيراد مكتبة الاهتزاز للتحكم في اهتزاز الجهاز

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // تأكيد تهيئة Flutter قبل بدء التطبيق
  await Firebase.initializeApp(); // تهيئة Firebase قبل استخدامه

  runApp(MyApp()); // تشغيل التطبيق
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // بناء الكلاس MyApp باستخدام StatelessWidget، الذي يمثل التطبيق الرئيسي

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // إخفاء شريط "Debug" الذي يظهر في أعلى التطبيق أثناء التطوير
      title: 'Wear OS Button and Text', // تعيين عنوان التطبيق
      theme: ThemeData(
        primarySwatch: Colors.blue, // تعيين اللون الأساسي للتطبيق (الأزرق)
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // تخصيص كثافة العناصر لتناسب الأنظمة المختلفة
      ),
      home: const Home(), // تعيين الشاشة الرئيسية للتطبيق (Home)
    );
  }
}
