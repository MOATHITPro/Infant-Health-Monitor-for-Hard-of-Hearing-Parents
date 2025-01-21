import 'package:flutter/material.dart'; // استيراد مكتبة Flutter الأساسية لبناء واجهة المستخدم.
import 'package:vibration/vibration.dart'; // استيراد مكتبة Vibration للتحكم في اهتزاز الجهاز.

class VibrationControlScreen extends StatefulWidget {
  final Function(String pattern, double intensity)
      onPatternSelected; // دالة يتم تمريرها من الخارج لاستقبال النمط وشدة الاهتزاز.

  VibrationControlScreen(
      {required this.onPatternSelected}); // بناء واجهة التحكم بالاهتزاز واستقبال الدالة المطلوبة.

  @override
  _VibrationControlScreenState createState() =>
      _VibrationControlScreenState(); // إنشاء الحالة المرتبطة بالشاشة.
}

class _VibrationControlScreenState extends State<VibrationControlScreen> {
  final List<String> patterns = [
    "Basic call"
  ]; // قائمة الأنماط المتاحة للاهتزاز (حاليًا تحتوي على نمط واحد).

  String selectedPattern = "Basic call"; // النمط الافتراضي للاهتزاز.
  double intensity = 128; // شدة الاهتزاز الافتراضية (منتصف النطاق).

  final Map<String, List<int>> patternMap = {
    "Basic call": [
      500,
      1000
    ], // خريطة تحدد أنماط الاهتزاز (القيم تمثل أوقات الاهتزاز والتوقف).
  };

  void vibrate() async {
    // دالة لتشغيل الاهتزاز بناءً على دعم الجهاز.
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      // إذا كان الجهاز يدعم الاهتزازات المخصصة.
      Vibration.vibrate(
        pattern: patternMap[selectedPattern] ?? [], // تحديد نمط الاهتزاز.
        intensities: List.filled(patternMap[selectedPattern]!.length,
            intensity.toInt()), // تطبيق شدة الاهتزاز على كل مرحلة.
      );
    } else if (await Vibration.hasVibrator() ?? false) {
      // إذا كان الجهاز يحتوي على محرك اهتزاز ولكنه لا يدعم الاهتزازات المخصصة.
      Vibration.vibrate();
    } else {
      // إذا كان الجهاز لا يدعم الاهتزاز.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Your device does not support vibration")), // عرض رسالة توضيحية.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; // الحصول على عرض الشاشة لتحديد المسافات النسبية.

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          // إضافة لمسة على العنوان للعودة إلى الشاشة السابقة عند الضغط.
          onTap: () {
            Navigator.pop(context); // العودة إلى الشاشة السابقة.
          },
          child: Text(
            "Vibration Control", // عنوان الشاشة.
            style: TextStyle(
              fontSize: 16, // حجم النص.
              color: const Color.fromARGB(255, 25, 135, 56), // لون النص.
            ),
          ),
        ),
        centerTitle: true, // محاذاة العنوان إلى الوسط.
        automaticallyImplyLeading: false, // إزالة أيقونة الرجوع الافتراضية.
        backgroundColor:
            const Color.fromARGB(255, 192, 223, 156), // لون خلفية شريط العنوان.
      ),
      backgroundColor: const Color(0xFFEEF6DE), // لون خلفية الشاشة.
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.all(screenWidth * 0.05), // إضافة مساحة حول المحتوى.
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // محاذاة المحتوى عموديًا في الوسط.
            crossAxisAlignment:
                CrossAxisAlignment.center, // محاذاة المحتوى أفقيًا في الوسط.
            children: [
              Slider(
                // مكون يسمح بتحديد شدة الاهتزاز.
                value: intensity, // القيمة الحالية للمنزلق.
                min: 1, // أقل قيمة.
                max: 255, // أعلى قيمة.
                divisions: 254, // عدد الأقسام بين القيم.
                activeColor:
                    const Color.fromARGB(255, 25, 135, 56), // لون الجزء النشط.
                inactiveColor: const Color.fromARGB(
                    255, 192, 223, 156), // لون الجزء غير النشط.
                onChanged: (value) {
                  // تحديث القيمة عند تغيير المستخدم لها.
                  setState(() {
                    intensity = value; // تحديث قيمة الشدة.
                  });
                  vibrate(); // تشغيل الاهتزاز فور تغيير القيمة.
                  widget.onPatternSelected(selectedPattern,
                      intensity); // تمرير النمط والشدة إلى الدالة المستقبلة.
                },
              ),
              SizedBox(height: 0), // إضافة مساحة صغيرة بين المنزلق والزر.
              ElevatedButton(
                // زر للعودة إلى الشاشة السابقة.
                onPressed: () {
                  Navigator.pop(context); // العودة إلى الشاشة السابقة.
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      const Color.fromARGB(255, 92, 90, 90), // لون النص.
                  backgroundColor:
                      const Color.fromARGB(255, 192, 223, 156), // لون الخلفية.
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5), // الحشوة الداخلية للزر.
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // جعل الزر بزوايا دائرية.
                  ),
                ),
                child: Text(
                  "Go Back", // النص داخل الزر.
                  style: TextStyle(fontSize: 16), // حجم النص.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
