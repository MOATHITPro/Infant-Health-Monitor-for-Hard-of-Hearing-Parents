import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vibration/vibration.dart';
import 'vibration_control_screen.dart'; // استيراد شاشة التحكم في الاهتزاز

// تعريف واجهة رئيسية Home
class Home extends StatefulWidget {
  const Home({super.key}); // تعريف المفتاح الافتراضي للعنصر

  @override
  _HomeState createState() => _HomeState(); // إنشاء حالة واجهة Home
}

// تعريف حالة واجهة Home
class _HomeState extends State<Home> {
  late DatabaseReference
      _babyStatusRef; // مرجع قاعدة بيانات Firebase لمتابعة حالة الطفل
  String displayedText =
      'Everything is fine\nMom'; // النص الافتراضي لعرض حالة الطفل
  bool showStopButton = false; // حالة عرض أو إخفاء زر الإيقاف
  String selectedPattern = "Basic call"; // نمط الاهتزاز الافتراضي
  double intensity = 128; // شدة الاهتزاز الافتراضية

  @override
  void initState() {
    super.initState();

    // ربط المرجع في قاعدة بيانات Firebase بمسار "baby_status/crying"
    _babyStatusRef = FirebaseDatabase.instance.ref('baby_status/crying');

    // الاستماع للتحديثات على النص القادم من Firebase
    _babyStatusRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        setState(() {
          displayedText = event.snapshot.value
              .toString(); // تحديث النص بما يتم قراءته من Firebase
          showStopButton = true; // عرض زر الإيقاف عند وصول رسالة جديدة
        });

        _triggerVibration(); // تفعيل الاهتزاز عند استقبال النص
        _deleteMessage(); // حذف الرسالة من قاعدة البيانات بعد تحديث النص
      }
    });
  }

  // وظيفة لتفعيل الاهتزاز باستخدام النمط والشدة المحددين
  void _triggerVibration() async {
    final Map<String, List<int>> patternMap = {
      "Basic call": [5000000, 10000000], // تحديد نمط الاهتزاز "Basic call"
    };

    // التحقق من دعم الجهاز لأنماط الاهتزاز المخصصة
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.vibrate(
        pattern: patternMap[selectedPattern] ?? [], // استخدام النمط المختار
        intensities: List.filled(patternMap[selectedPattern]!.length,
            intensity.toInt()), // تطبيق الشدة
      );
    } else if (await Vibration.hasVibrator() ?? false) {
      Vibration
          .vibrate(); // تفعيل الاهتزاز البسيط إذا لم يكن هناك دعم للأنماط المخصصة
    } else {
      // عرض رسالة في حالة عدم دعم الجهاز للاهتزاز
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your device does not support vibration")),
      );
    }
  }

  // وظيفة لإيقاف الاهتزاز عند الضغط على الزر
  void _stopVibration() {
    Vibration.cancel(); // إيقاف الاهتزاز
    setState(() {
      displayedText =
          'Everything is fine\nMom'; // إعادة النص إلى الحالة الافتراضية
      showStopButton = false; // إخفاء زر الإيقاف
    });
  }

  // وظيفة لحذف الرسالة من قاعدة بيانات Firebase
  void _deleteMessage() {
    _babyStatusRef.remove(); // حذف الرسالة من المسار "baby_status/crying"
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // عرض الشاشة
    double textScaleFactor =
        MediaQuery.of(context).textScaleFactor; // عامل قياس النص

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My baby voice', // عنوان التطبيق
          style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(255, 25, 135, 56)), // تنسيق النص
        ),
        centerTitle: true, // توسيط العنوان في شريط التطبيق
        backgroundColor:
            const Color.fromARGB(255, 192, 223, 156), // لون الخلفية
      ),
      backgroundColor: const Color(0xFFEEF6DE), // لون خلفية الصفحة
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // حواف داخلية نسبية
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // محاذاة العناصر في المنتصف
            children: <Widget>[
              const SizedBox(height: 10), // مسافة عمودية صغيرة
              // عرض النص الأول من الرسالة
              Text(
                displayedText.split('\n').first,
                style: TextStyle(
                  fontSize: 20 *
                      textScaleFactor, // تكبير النص بناءً على إعدادات الجهاز
                  color: const Color.fromARGB(255, 23, 131, 53), // لون النص
                ),
              ),
              // عرض النص الثاني إذا كان موجودًا
              Text(
                displayedText.split('\n').length > 1
                    ? displayedText.split('\n').last
                    : '', // عرض النص الثاني إن وجد
                style: TextStyle(
                  fontSize: 20 * textScaleFactor,
                  color: const Color.fromARGB(255, 23, 131, 53),
                ),
              ),
              const SizedBox(height: 5), // مسافة بين النص والأزرار
              // زر للإعدادات أو إيقاف الاهتزاز حسب الحالة
              Container(
                width: 100, // عرض الزر
                height: 40, // ارتفاع الزر
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 192, 223, 156), // لون الخلفية
                  borderRadius: BorderRadius.circular(8), // زوايا مستديرة
                ),
                child: TextButton(
                  onPressed: showStopButton
                      ? () {
                          _stopVibration(); // إيقاف الاهتزاز
                          _deleteMessage(); // حذف الرسالة
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VibrationControlScreen(
                                      onPatternSelected: (pattern, intensity) {
                                        setState(() {
                                          selectedPattern =
                                              pattern; // تحديث النمط
                                          this.intensity =
                                              intensity; // تحديث الشدة
                                        });
                                      },
                                    )),
                          ); // الانتقال إلى شاشة التحكم في الاهتزاز
                        },
                  child: Text(
                    showStopButton ? 'Ok Baby' : 'Setting', // النص حسب الحالة
                    style: const TextStyle(
                      color: Color.fromARGB(255, 131, 131, 131), // لون النص
                      fontSize: 14, // حجم النص
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
