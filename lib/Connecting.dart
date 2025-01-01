import 'package:flutter/material.dart';

class Connecting extends StatefulWidget {
  const Connecting({super.key});

  @override
  _ConnectingState createState() => _ConnectingState();
}

class _ConnectingState extends State<Connecting> {
  String _message = 'Not Connected';

  // دالة لتغيير النص عند الضغط على الزر
  void _changeMessage() {
    setState(() {
      _message = 'Connected';
    });
  }

  // دالة للرجوع إلى الصفحة السابقة
  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double textSize = screenWidth < 400 ? 14 : 18;

    double buttonWidth = 100; // تحديد عرض الزر
    double buttonHeight = 40.0;

    double verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ESP32',
          style:
              TextStyle(fontSize: 18, color: Color.fromARGB(255, 25, 135, 56)),
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
              // زر الاتصال بأيقونة الواي فاي فقط
              Container(
                width: buttonWidth, // عرض الزر
                height: buttonHeight, // ارتفاع الزر
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 192, 223, 156), // خلفية الزر
                  borderRadius: BorderRadius.circular(8), // زوايا مستديرة
                ),
                child: TextButton(
                  onPressed: _changeMessage,
                  child: const Icon(
                    Icons.wifi, // أيقونة الواي فاي
                    color: Color.fromARGB(255, 131, 131, 131), // لون الأيقونة
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing), // مسافة بين الزر والنص
              Text(
                _message,
                style: TextStyle(
                  fontSize: textSize * 0.8, // حجم النص أصغر بنسبة 80%
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(), // إضافة مساحة لدفع زر الرجوع للأسفل
              // زر الرجوع
              Container(
                width: buttonWidth, // عرض الزر
                height: buttonHeight, // ارتفاع الزر
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 192, 223, 156), // خلفية الزر
                  borderRadius: BorderRadius.circular(8), // زوايا مستديرة
                ),
                child: TextButton.icon(
                  onPressed: _goBack,
                  icon: const Icon(Icons.arrow_back,
                      color:
                          Color.fromARGB(255, 131, 131, 131)), // أيقونة الرجوع
                  label: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(
                          255, 131, 131, 131), // لون النص للأزرار
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
