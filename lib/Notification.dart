import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // قائمة التنبيهات
  final List<String> _notifications = [
    'New message from John',
    'Battery level low',
    'WiFi connection lost',
    'New message from Sarah',
    'Low storage space',
    'App update available',
    'Bluetooth disconnected',
    'Location permission needed',
    'New email received',
    'Reminder: Meeting at 3 PM',
  ];

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على حجم الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // حساب حجم النص بناءً على حجم الشاشة
    double textSize = screenWidth < 400 ? 16 : 20; // تعيين حجم نص مناسب

    // حساب المسافة بين العناصر بناءً على حجم الشاشة
    double verticalSpacing =
        screenHeight * 0.02; // 2% من ارتفاع الشاشة للمسافات بين العناصر
    double padding = screenWidth * 0.05; // 5% من العرض للحشو

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          textAlign: TextAlign.center, // لتوسيط النص
        ),
        centerTitle: true, // تأكد من أن العنوان في المنتصف
        flexibleSpace: Container(
          alignment: Alignment.center, // لضمان وضع العنوان في المركز
        ),
        elevation: 0, // إلغاء الظل أسفل الـ AppBar
        automaticallyImplyLeading: false, // إلغاء زر الرجوع
      ),
      body: Padding(
        padding: EdgeInsets.all(padding), // حشو ديناميكي يناسب حجم الشاشة
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            // يمكنك إضافة منطق خاص هنا للتفاعل مع أحداث التمرير
            if (notification is ScrollUpdateNotification) {
              // تفاعل مع التمرير باستخدام عجلة الفأرة أو التمرير اليدوي
              // يمكنك إضافة أي منطق إضافي هنا إذا رغبت في التأثير على التمرير
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // استخدام ListView لعرض التنبيهات
                for (int i = 0; i < _notifications.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalSpacing), // مسافة بين كل عنصر
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50], // خلفية فاتحة
                        borderRadius: BorderRadius.circular(10), // حواف مستديرة
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.notifications,
                            color: Colors.blue), // إضافة الأيقونة
                        title: Text(
                          _notifications[i],
                          style:
                              TextStyle(fontSize: textSize), // تعديل حجم الخط
                        ),
                      ),
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
