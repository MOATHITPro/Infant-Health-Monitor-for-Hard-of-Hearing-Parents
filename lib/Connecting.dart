import 'package:flutter/material.dart';

class Connecting extends StatefulWidget {
  const Connecting({super.key});

  @override
  _ConnectingState createState() => _ConnectingState();
}

class _ConnectingState extends State<Connecting> {
  String _message = 'not Connect';

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
    // استخدام MediaQuery للحصول على حجم الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // حساب حجم النص بناءً على حجم الشاشة
    double textSize = screenWidth < 400 ? 16 : 20;

    // حساب حجم الزر بناءً على العرض
    double buttonWidth = screenWidth * 0.6; // الزر سيأخذ 60% من العرض
    double buttonHeight = 40;

    // حساب المسافات بين العناصر بناءً على حجم الشاشة
    double verticalSpacing =
        screenHeight * 0.02; // 2% من ارتفاع الشاشة للمسافات بين العناصر
    double padding = screenWidth * 0.05; // 5% من العرض للحشو

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wear OS'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        // مركزية المحتوى
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // محاذاة العناصر في الوسط عمودياً
            crossAxisAlignment:
                CrossAxisAlignment.center, // محاذاة العناصر في الوسط أفقياً
            children: <Widget>[
              ElevatedButton(
                onPressed: _changeMessage,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                ),
                child: Text('Connect',
                    style: TextStyle(fontSize: textSize * textScaleFactor)),
              ),
              SizedBox(height: verticalSpacing), // لتوفير مسافة بين الزر والنص
              Text(
                _message,
                style: TextStyle(
                    fontSize: textSize * textScaleFactor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Spacer(), // يضيف مساحة فارغة لدفع زر الرجوع إلى أسفل الصفحة
              Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: ElevatedButton(
                  onPressed: _goBack,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(buttonWidth, 30),
                  ),
                  child: const Text('Back', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
